# DockerBIO
Web application for efficient use of bioinformatics tools


Docker Pull Command
Docker name	: netbuyer/dockerbio
Download1	: docker pull netbuyer/dockerbio
Download2	: docker pull netbuyer/dockerbio:0.3
* Download1 includes only DockerBIO
* Download2 includes a reference(hg38), dbSNP and DockerBIO.


Introducing projects
Bioinformatics tools are being developed with various program languages and tested on various operating systems.. Biologists and bioinfomaticians want to build pipelines using a variety of tools, but it is not easy to compile, install and incorporate them into pipelines. DockerBIO is designed for biologists to easily use various bioinformatics tools from DockerHub, and easily make pipelines using these tools.
By default, DockerBIO has most of the essential tools for NGS analysis such as Whole Genome analysis pipeline, RNA-Seq analysis pipeline, FastQC (quality check tool for fastq files), SnpShift (vcf annotation tool), Samtools, BWA (alignment tools), GATK (vcf calling tool), etc. However, users can register and use any tools and data on DockerBIO. For more information, please refer to Kwon et al., “DockerBIO: Web application for efficient use of bioinformatics Docker images”.
DockerBIO is available for Linux (both Centos and Ubuntu) and Mac OS. Windows is not fully supported due to hyper-v issues.
DockerBIO is a web program based on java spring created with two Spring Boot modules.
-	SpringbootAsyn cJob - Asynchronous Module for Docker Implementation Monitoring
-	SpringbootFileupload - Module to upload user files

Part 1 – For Easy Installation
1.	Install Docker at your PC, workstation, or server (https://www.docker.com/)
2.	Enter the following commands:

  $ docker pull netbuyer/dockerbio
  $ mkdir /data/dockerbio

3.	(optional) You can download and unzip files containing the Reference DB / SNP DB files from following repositories, and place them at /data/dockerbio.
Google drive: https://drive.google.com/drive/folders/16jkIWSJbFYmrZ0GjJrMDq7trW714JYvI

Sharefile: https://mygenomeboxmygenomebox.sharefile.com/share/view/sdcce93756ad45978

In above repositories, you can download one or more of following files:
1) dbAll.tar.gz : a compressed version of all versions of dbSNP
2) refDbAll.tar.gz : a reference databases containing hg19 and hg38
3) dockerbio_extra.tar.gz : a compressed version of both Reference hg38 and dbSNP150(hg38 ver)

4.	Supposing you choose dockerbio_extra.tar.gz, you can unzip it with the following command:

  $ tar xvzf dockerbio_extra.tar.gz

After unzipping, the folders will be created in the form shown below.
/data/dockerbio/
............................upload/ (upload folder)
............................db/ (Snp db folder)
............................refDb/ (refrence db folder)
............................sample/ (sample folder)
............................user/ (user file folder)
.............................temp/ (temporary upload folder)

5.	To run dockerBIO, enter the following command:

$docker run -dit -h dockerbio --name dockerbio --privileged -v /data/dockerbio:/data/dockerbio -v /var/run/docker.sock: /var/run/docker.sock -p 8080:8080 -p 8090:8090 -p 8092:8092 -e HOSTIP=http://Service_Host_IP netbuyer/dockerbio:0.1 bash

6.	Service_Host_IP should be replaced with your (public) ip (example : 192.168.24.24).

$ docker exec dockerbio /opt/restart.sh
7.	In the browser address bar, type http://Service_Host_IP:8080

Part 2 - For Easy Use
The first time, you can log in as ID: user@user.com and Password: User1234. After first login, making new account is strongly recommended. You can make a new account on the system.
After you successfully login to your DockerBIO page, you will be able to see "RegisterDocker" at which you can register new Docker and "Run Docker" menu at which you can execute the registered Docker from "Register Docker".

	Run Docker
First, drag and drop files you want to analyze into the UPLOAD USER FILE menu, and then check the files in the "user file Select" menu.
Second, execute the desired program. You can run the dockers registered in the "Job Select" menu. For whole genome analysis, select _WGS (netbuyer/wgs) in the Job Select menu and select needed files from the user file Select menu, and then click the Run Docker menu.
Most options can be changed as needed, but we recommend using the default options tested in "Register Docker" and changing the version of REF DB or dbSNP as needed. If you need to modify it, you can create a new option in the Register Docker menu. We will show examples of the most commonly used tools, BWA, FastQC, SnpSift, WGS pipeline, and WTS pipeline.


	Register Docker
This page provides functions for downloading a number of bioinformatics tools registered in DockerHub and registering them with DockerBIO. This page consists of two menus: Docker LIST and Docker Info Register. Docker LIST is a menu to test whether the registered options  works. The Docker Info Register can be used to search for Docker images in DockerHub and download them to the current system. It also provides functions for setting various options.
	Docker LIST
If you click the EDIT button in the action menu, you can see the menus in the Docker Info Register and modify options if necessary. After setting the options, you need to click the TEST button to set the best option in the SIMULATE Docker window. You can test whether the Docker is working using your options and see it in Run Docker. If you want to change the current Run Docker options, you can modify them here.

	Docker Info Register
Please click Search-Docker-ID to open the Docker search window and search for the desired search term. If you search for bwa keywords, more than 300 bwa entries registered in DockerHub are searched. After selecting a docker (if you are not sure which one to choose, it will be good to choose one with a large number of downloads or a large number of stars), click the select button to register it in Docker ID.
Next, you can set Docker Name, and output TYPE. There are three types: LOG, FILE, and DIR. LOG selects the log file of the result file if desired, FILE is used when the result should be used to create a file, and DIR selects “log file Select” to save the resulting file.
Reference DB is a menu for selecting Reference, and now only one DB can be selected.
dbSNP is a menu to select the SNP database, and you can specify several.
The Options menu can be set by typing additional options when you need to type them.
When all the options are set, you can check the command with the Check Docker Command button.
If you click the Create button, a new job will be registered in the Docker List and you can run the test.
If you follow the whole procedure in the manual, you will find a lot of tools registered in DockerHub. You will be able to use it easily after registering and testing without difficulty of installation; however, you will need to learn how to test basic tools yourself.
