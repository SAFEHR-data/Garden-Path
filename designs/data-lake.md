# Design for FlowEHR Data Lake

| Author                     | Issue                                              |
|----------------------------|----------------------------------------------------|
| James Griffin (@jjgriff93) | https://github.com/UCLH-Foundry/FlowEHR/issues/160 |


## Context

FlowEHR enables data engineers to develop pipelines that transform data from raw sources into a high-quality data store that powers analytics, machine learning and more. In a medallion structure, we would consider this a transformation from a "bronze" layer through to "gold".

Currently, FlowEHR provides infrastructure for running transformations (via Databricks) and for storing features (the SQL feature store which we can also consider the "gold" layer); however, it does not support multi-modal data, it does not provide mechanisms for storing the intermediary stages of these transformations from raw to gold, and is not opinionated on how this data is stored.


## Proposal

To make it as easy as possible for data engineers to get started in developing pipelines, and to provide an existing storage structure to enforce industry best practices out-of-the-box, I propose the introduction of a datalake component to the FlowEHR platform.

### What is a Data Lake?

A data lake is a massively scalable and secure data storage for high-performance analytics workloads. Due to the volume of data that modern organisations need to deal with, data lakes have become a defacto choice for storing, analysing and consuming data at scale.

In Azure terms, the Azure Data Lake Storage Gen2 service is a hierarchical file system built on top of Blob Storage, which provides the following benefits:

- **Massive scale**: Store and process trillions of files.
- **Cost-effective**: Pay only for what you use.
- **Optimized performance**: High throughput and low latency.

As the underlying storage is file-based, the data lake can store high quantities of multi-modal data in one place: structured data (tables - CSV, Parquet etc.), unstructured data, images, videos, etc.

Integrating this with FlowEHR, alongside a number of best-practices with managing a data lake, will enable adopters of the platform to get started with data engineering in a scalable and robust way.

One advantage of using Data Lake and Spark is ability to use Delta tables. They can easily be [created from Databricks Runtime](https://learn.microsoft.com/en-us/azure/databricks/delta/tutorial#--create-a-table) as well as [Synapse](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-delta-lake-overview?pivots=programming-language-python#create-a-table) using a statement `df.write.saveAsTable("myTableName")`. Delta Tables have versioning enabled by default which allows to track all updates to the tables. They can also [track row-level changes](https://learn.microsoft.com/en-us/azure/databricks/delta/delta-change-data-feed) which can be read downstream for incremental processing. They have many other useful features such as [automatic schema validation](https://learn.microsoft.com/en-us/azure/databricks/delta/schema-validation) and are a widespread storage format for Big Data processing.

### Data Lake best practices

To avoid "data swamps", where a data lake becomes a dumping ground for data without any structure or governance, there are a number of [best practices](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/best-practices/data-lake-overview#data-lake-planning) to consider, one of which is zones.

Zones guarantees atomicity, consistency, isolation, and durability as data passes through multiple layers of validations and transformations before being stored in a layout optimized for consumption. Each zone is essentially its own filesystem with a heirarchical folder structure. In a medallion structure, as alluded to before, a simple implementation of zones could be:

- **Bronze**: Invalidated raw data, maintaining the same structure as the source(s)
    - Maintains the raw state of the data source
    - Is appended incrementally and grows over time
    - Can be any combination of streaming and batch transactions
- **Silver**: validated, de-duplicated and enriched
    - Has undergone validation, quality checks and enrichment
    - Can be trusted and optimised for downstream analytics
- **Gold**: curated, filtered and aggregated
    - Optimised for data consumers
    - Powers analytics, machine learning, and production applications

We should seek to provide a simple implementation of this structure out-of-the-box, whilst allowing organisations to expand and customise this structure to their needs. More information on zone structures is available [here](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/best-practices/data-lake-zones).

### Integrating with FlowEHR

#### Configuration

To ensure we don't disrupt existing deployments of FlowEHR, I propose we introduce this component as an opt-in feature. We can add a new block to the configuration as follows:

```yaml
transform:
    datalake:
        # additional configuration
```

If the `data_lakehouse` block is not present, no changes will be made to the existing behaviour of FlowEHR. If defined, users can specify the zones they wish to deploy as follows:

```yaml
zones:
- name: Bronze
  containers:
    - name: Raw
- name: Silver
  containers:
    - name: Transformed
- name: Gold
  containers:
    - name: Curated
```

The objects under zones represent the data lakes to deploy (an Azure Data Lake Storage gen2 Filesystem), and the containers represent the storage container(s) within each filesystem.

#### Infrastructure

The new infrastructure to deploy will live in the `infrastructure/transform` Terraform module and will comprise of the following:

- Storage Account with Heirarchical Namespaces enabled (Azure Data Lake Storage Gen2)
- ADLS Gen2 Filesystem(s) (for each configured zone)
- Storage Container(s) (a `azurerm_storage_data_lake_gen2_path` for each configured container)
- ADLS private networking (private endpoint, dns zone and private link)
- ADLS role assignments for Azure Data Factory and Databricks
- Databricks ADLS filesystem mounts for each zone
- Service principal for Databricks identity access to ADLS
- Databricks secrets for SP credentials
- ADF linked service for ADLS

As mentioned, if the `datalake` configuration block is not present, none of this infrastructure will be deployed by utilising a dynamic flag.


## Considerations

- What do we do with the SQL DB longer term? Do we deprecate it in favour of the data lake?

Given that the current "gold" layer in FlowEHR is the SQL DB, we should consider whether it would be superseded by ADLS. This will greatly simplify the architecture of FlowEHR; however the SQL Server currently also serves as the query layer for applications and data scientists / ML models.

We would need to provide another mechanism for querying and analysing data in the data lake, which could include:
- Through the existing [Databricks workspace](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark)
    - this would be the most seamless option but would require users and apps/models to have access to Databricks, which might not be viable (i.e. users might be accessing from a TRE)
    - [Delta Lake](https://learn.microsoft.com/en-us/azure/databricks/delta/) could be used to further optimise for analytics. This could be used to implement the [Data Lakehouse](https://www.oracle.com/big-data/what-is-data-lakehouse/) pattern, essentially adding a query/metadata layer to each stage of the data lake as described in the [Databricks docs](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/)
- [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/data-explorer/data-lake-query-data)
    - Multiple SDKs including Python that can be used to query data but another service to add into the mix
- [Azure Machine Learning Datastore](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-datastore?view=azureml-api-2&tabs=sdk-identity-based-access,sdk-adls-identity-access,sdk-azfiles-accountkey,sdk-adlsgen1-identity-access)
    - Useful for ML workloads but not for general querying

An alternative might be that the SQL DB is shifted to the right, and is considered just a feature store layer on top of gold for the time being. This might eventually be replaced by a tailor-made feature store like [AML Feature Store](https://learn.microsoft.com/en-us/azure/machine-learning/concept-what-is-managed-feature-store?view=azureml-api-2).

> For our users' immediate needs, we should make SQL DB optional via config in the same way as data lake will be configured to avoid uneccessary cost and complexity if not required. We should add a feature to the backlog to prompt discussion on the future of SQL DB as part of FlowEHR and potential replacements/improvements, and address separately to the initial data lake implementation.

- Where does OneLake/Microsoft Fabric fit into this?

Currently in preview, [OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) is a managed data lake service that forms part of the [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview) platform. There is integration with Azure Databricks and other Azure services, and there will be a migration path to OneLake from ADLS - so in implementing an ADLS data lake into FlowEHR, this opens up this migration as a potential evolution of FlowEHR in future.
