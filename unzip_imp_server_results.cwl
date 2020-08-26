{
    "class": "CommandLineTool",
    "cwlVersion": "v1.0",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "baseCommand": [
        "bash /usr/local/bin/unzip_imp_server_results.sh"
    ],
    "inputs": [
        {
            "id": "curl_url",
            "type": "string",
            "inputBinding": {
                "position": 1,
                "shellQuote": false
            },
            "doc": "URL to use in the curl command to download TOPMed imputation zip files"
        },
        {
            "id": "zip_pwd",
            "type": "string",
            "inputBinding": {
                "position": 2,
                "shellQuote": true
            },
            "doc": "Password for unzipping files"
        }
    ],
    "outputs": [
        {
            "id": "output",
            "type": "File[]?",
            "outputBinding": {
                "glob": "*.gz"
            }
        }
    ],
    "label": "unzip_imp_server_results",
    "requirements": [
        {
            "class": "ShellCommandRequirement"
        },
        {
            "class": "ResourceRequirement",
            "ramMin": 4000,
            "coresMin": 1
        },
        {
            "class": "DockerRequirement",
            "dockerPull": "quay.io/mdaya/topmed_imputation:1.0"
        }
    ],
    "hints": [
        {
            "class": "sbg:AWSInstanceType",
            "value": "m4.large;ebs-gp2;1024"
        }
    ]
}
