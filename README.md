Pipeline for imputing autosomal GWAS array data with hg19 coordinates to the
TOPMed reference panel (which requires liftover to hg38 coordinates) on the
Michigan Imputation server. 

## Software requirements

The following command line tools are assumed to be installed and in the system
path:

* plink (v1.9 and later)
* VCFtools
* bgzip
* CrossMap (http://crossmap.sourceforge.net)
* 7zip (if downloading files to a local machine)

## Input files

* GWAS array data in the binary plink file format

## Step 1

Run the create\_initial\_files.sh script to create the initial input files to
upload to the Michigian Imputation server for pre-imputaiton QC

<code>bash create\_initial\_files.sh \<plink\_file\_prefix\> \<out\_dir\></code>

Notes: 

* If QC was already run on the PLINK input files, you may want to comment out the "pre-imputation QC" step in the script
* Check (and record for future reference e.g. paper write-up) the output printed at the end of the script - excess number of SNPs removed may point to an unexpected problem in the workflow

## Step 2

Upload the output pre-QC files from Step 1 to the Michigan imputation server for
imputation QC against the TOPMed reference panel

* Select Array Build GRCh38/hg38 (this was taken care off by the previous steps and makes it easier to do strand flips in the next step)
* Skip the QC frequency check - TOPMed is a mixed ancestry reference panel so this step may flag allele frequency differences that are actually OK
* Select Quality Control only

Once the QC has run, check the output on the imputation server, and download the
snps-excluded.txt file to the same directory as the pre-QC input files.
It is a good idea to also download the typed-only.txt files and
chunks-excluded.txt files as well, in case you ever need to refer back to this.

## Step 3

Run the fix\_strands.sh script to flip strands of variants identified as such in
the snps-exlcuded.txt file - this will produce the final post QC VCF files for
imputation

<code>fix\_strands.sh \<pre\_qc\_dir\> \<post\_qc\_dir\></code>

## Step 4

Upload the output post QC VCF files from Step 3 to the Michigan imputation server for
imputation against the TOPMed reference panel

* Select Array Build GRCh38/hg38 
* Skip the QC frequency check 
* Select Quality Control and imputation

## Step 5

### To download and unzip files to a local machine

The imputation server will send an email with a download link once the
imputations are done. Use the wget commands to download the imputed files to the
desired folder. After the download completed, use the unzip\_results.sh script to unzip the files with the
provided password.

<code>unzip\_results.sh \<impute\_\dir> \<zip\_password\></code>

### To download and unzip files directly to a Seven Bridges Biodata Catalyst project

Use unzip\_imp\_server\_results.cwl to create a Seven Bridges tool. The docker
image in the Dockerfile describes the compute environment required for running
the tool. 

The imputation server will send an email with a download link once the
imputations are done. Use the unzip\_imp\_server\_results.cwl tool to download and unzip files. 
The URL from the example curl command should be used to set the curl\_url parameter, 
and the provided password from the email shoud be used for the zip\_pwd parameter. 


