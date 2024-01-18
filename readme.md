Make ocrd_tesserocr work like it works in ocrd_all

### Notes
- ocrd_tesserocr-copy:
    - copy of https://github.com/OCR-D/ocrd_tesserocr with latest head: f1036e3
    - only Dockerfile differs
    - **building the image takes about 5 minutes** on my machine

- docker-compose.ocrdall.yaml:
    - docker-compose file completely based on ocrd/all:maximum

- docker-compose.yaml:
    - like docker-compose.ocrdall.yaml but container ocrd-tesserocr-recognize build from custom
      Dockerfile

- **run-test.sh**:
    - this starts the docker-setup and runs the workflow. Additionally it cleans the workspace and
      stops possibly running containers from a previous run.
    - **use this to reproduce the error**

- my_ocrd_logging.conf:
    - this is needed in custom ocrd-tesserocr-recognize container, because of log-file permission
      problems (in the Dockerfile a call to `ocrd` creates a logfile with root permission. The
      container later runs with 1000:1000 user, which results in a permission error when trying to
      access the logfile. The custom log-config prevents trying to access the logfile created in the
      process of image creation)

### Testrun
- run the testscript
    - all containers use ocrd/all:maximum except ocrd-tesserocr-recognize. This uses the custom
      Dockerfile from `ocrd_tesserocr_copy`
```
./run-test.sh
```
- at the end the testscript prints a line to query the current status of the workflow, e.g.
  `curl "localhost:8000/workflow/job/{the-job-id}" | jq`
- when the workflow is finished (takes about 1.5 minutes on my machine) following output is expected
  (job-ids differ):
```
{
  "ocrd-olena-binarize": {
    "SUCCESS": 10
  },
  "ocrd-anybaseocr-crop": {
    "SUCCESS": 10
  },
  "ocrd-cis-ocropy-denoise": {
    "SUCCESS": 10
  },
  "ocrd-tesserocr-segment-region": {
    "SUCCESS": 10
  },
  "ocrd-segment-repair": {
    "SUCCESS": 10
  },
  "ocrd-cis-ocropy-clip": {
    "SUCCESS": 10
  },
  "ocrd-cis-ocropy-segment": {
    "SUCCESS": 10
  },
  "ocrd-cis-ocropy-dewarp": {
    "SUCCESS": 10
  },
  "ocrd-tesserocr-recognize": {
    "SUCCESS": 8,
    "FAILED": 2
  },
  "failed-processor-tasks": {
    "ocrd-tesserocr-recognize": [
      {
        "job_id": "cefdcb63-f328-4e05-bedf-d674ce9236d3",
        "page_id": "PHYS_0004"
      },
      {
        "job_id": "b2d950b0-4bc7-48fc-8212-ca7ae1330eb6",
        "page_id": "PHYS_0006"
      }
    ]
  }
}
```
- this shows that two filegroups fails: 4 & 6
- when run with completely ocrd-all (use `cp docker-compose-ocrdall.yaml docker-compose.yaml`
  therefor) everything works
