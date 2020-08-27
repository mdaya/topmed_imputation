class: CommandLineTool
cwlVersion: v1.0
label: unzip_imp_server_results
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 4000
- class: DockerRequirement
  dockerPull: quay.io/mdaya/topmed_imputation:0.1

inputs:
- id: curl_url
  doc: URL to use in the curl command to download TOPMed imputation zip files
  type: string
  inputBinding:
    position: 1
    shellQuote: false
- id: zip_pwd
  doc: Password for unzipping files
  type: string
  inputBinding:
    position: 2
    shellQuote: true

outputs:
- id: output
  type: File[]?
  outputBinding:
    glob: '*.gz'

baseCommand:
- bash /usr/local/bin/unzip_imp_server_results.sh

hints:
- class: sbg:AWSInstanceType
  value: m4.large;ebs-gp2;1024
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/midaya/fhs-imputed/unzip-imp-server-results/0/raw/
sbg:appVersion:
- v1.0
sbg:content_hash: ab94c27ccdad62f677b31e2d3cc3c3bd7a95f2c0f76cfd78a2670fa35e3a4c2e7
sbg:contributors:
- midaya
sbg:copyOf: midaya/cag/unzip-imp-server-results/7
sbg:createdBy: midaya
sbg:createdOn: 1598390838
sbg:id: midaya/fhs-imputed/unzip-imp-server-results/0
sbg:image_url:
sbg:latestRevision: 0
sbg:modifiedBy: midaya
sbg:modifiedOn: 1598390838
sbg:project: midaya/fhs-imputed
sbg:projectName: FHS_imputed
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of midaya/cag/unzip-imp-server-results/7
sbg:revisionsInfo:
- sbg:modifiedBy: midaya
  sbg:modifiedOn: 1598390838
  sbg:revision: 0
  sbg:revisionNotes: Copy of midaya/cag/unzip-imp-server-results/7
sbg:sbgMaintained: false
sbg:validationErrors: []
