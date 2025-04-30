# Dockerized Hermes and Hades

This repository contains a **Dockerized version** of the [Hermes](https://github.com/wardle/hermes) and [Hades](https://github.com/wardle/hades) services, designed to streamline deployment and facilitate easy integration of SNOMED CT data.

## Purpose

The goal of this setup is to provide an easy and efficient way to deploy **Hermes** and **Hades** in containers, allowing for the automatic import and indexing of SNOMED CT RF2 data and subsequent API access.

- **Hermes** is used for importing and indexing SNOMED CT RF2 data.
- **Hades** provides the API service for querying the indexed SNOMED CT database.

## Prerequisites

- **Docker** installed on your machine.
- **Docker Compose** to manage multi-container services.

## Getting Started

### 1. Obtain the `docker-compose.yml`

First, make sure you have the `docker-compose.yml` file and the SNOMED CT RF2 data ready. If you don't have the data yet, you can download the SNOMED CT RF2 dataset from [SNOMED International](https://www.snomed.org/snomed-ct/get-snomed).

You do **not** need to clone the repository. You can just download or create the `docker-compose.yml` file from this repository.

### 2. Prepare SNOMED CT RF2 Data

Before starting the services, you need the SNOMED CT RF2 data on your local machine. The data should be placed in the correct directory before starting the services.

- Download the SNOMED CT RF2 data.
- Make sure the RF2 data is available in a directory (e.g., `/path/to/snomed-rf`).

### 3. Start the Services

With the SNOMED CT RF2 data ready, now you can start the **Hermes** and **Hades** containers using Docker Compose.

Run the following command to start the containers:

```sh
docker-compose up
```

This will:

- Build and start the **Hermes** and **Hades** containers.
- **Hermes** will import and index the SNOMED CT RF2 data. It will wait for the RF2 data to be available before starting the import process.
- **Hades** will only start once **Hermes** has completed the import and indexing process.

### 4. Upload SNOMED CT RF2 Data to the Running Container

Once the services are up and running, you can copy the SNOMED CT RF2 data into the **Hermes** container. **Hermes** will then use this data to perform the import and indexing.

To copy the SNOMED CT RF2 data into the container, use the following command:

```sh
docker cp /path/to/snomed-rf hermes:/data/snomed-rf
```

Ensure that the `/path/to/snomed-rf` is the actual path to the RF2 data on your local machine.

### 5. Access the Hades API

Once the **Hermes** container finishes its task (importing and indexing), the **Hades** container will automatically start, and the SNOMED CT API will be available on port `8080`. You can access it by navigating to:

```sh
curl -X GET "http://localhost:8080/fhir/metadata"
```

This will show the capability statement of the terminology server.

### 6. Stopping the Services

To stop the services, run:

```sh
docker-compose down
```

This will stop the containers but retain the volume with the SNOMED CT data. If you want to remove the volume as well, you can use:

```sh
docker-compose down -v
```

---

## Docker Compose Overview

The `docker-compose.yml` file defines two services:

- **Hermes**:
  - Waits for the SNOMED CT RF2 data to be available and then imports and indexes it.
  - After completing the import and indexing, **Hermes** exits.

- **Hades**:
  - Waits for **Hermes** to complete and then starts the SNOMED CT API on port `8080`.

### Key Files

- **Hermes script**: `build-db.sh`
- **Volume for SNOMED CT data**: `/data`

---

## Contributing

Contributions to improve the setup, configuration, or documentation are always welcome. Feel free to fork the repository and submit pull requests.

## License

This project is a Dockerized integration of:
- [Hermes](https://github.com/wardle/hermes) - EPL-2.0 License
- [Hades](https://github.com/wardle/hades) - EPL-2.0 License

All original code in this repository (Dockerfiles, scripts, configuration) is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Hermes and Hades are distributed under the Eclipse Public License 2.0.
