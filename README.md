## Distributed File System (DFS)
### Nikita Mokhnatkin, Niyaz Kashapov, Sergey Grebennikov

[Demonstration Video](https://youtu.be/oa4sLbRMZF8)

dockers:
vkaser/dfs:latest  - Storage server
innost5/dfsclient:latest - Client
aminiosa/dsns1 - Name server 


Task: Make a Distributed File System

#### Architecture
![](https://i.imgur.com/XXQG0En.png)


### How to use

All DFS can be tested on the Docker. To start using, `bash.sh` script should be run. This script starts docker container with name server. Storage Servers are running by `docker run -it vkaser/dfs` command. Client needs  `docker run -it innost5/dfsclient:latest` command.

#### Client by *Niyaz Kashapov* 

Client can be started in the Docker by  `docker run -it innost5/dfsclient:latest` command or by standalone python script - `DFScli.py`.
The `DFScli.py` script uses location folder as home folder (to use cache). It is *strongly* recommended to start script in **empty folder**.
Python script is executed by Python 2.7 with following command: 
```tempforcache$ python DFScli.py```
The client welcomes the user with the command line. This command line interface is very similar to native Linux Command Line but has some differences. A supported command are shown in the Table 1:



| Functionality |  Command | Description |
| :---: | :----------: |:--------: |
| Initialize |   `init`   | Initialize system, search a new Name Server in the local network |
| File Read  |   `rd /path/filename` | This command downloads file to cache |
| File write |   `wr filename` | Upload file to Storage Service from the cache. |
| File delete|   `rm /path/filename`| Removing the file from the DFS  |
| File info  |   `info /path/filename` | Shows date of creating, size of the file and adress of the Storage Server|
| Open directory |   `cd /pathToFolder   ` or `cd folder ` | Changes current directory. Can be direct and relative path to the folder. Maintains `.` and `..` signs |
| Read directory |  `ls /path` or `ls`  |  List files and directory  inside the directory  |
| Make directory |   `mkdir folderName` | Makes a directory in the current    directory  |
| Delete directory|   `rm folderName`    | Deletes folder if the folder does not exist files.  |
| Linux Command Line Commands |`nano file`, `more file`, `cat file`, `tail file`| Executes utilities on the file from DFS. Some utilities and commands can be crashed or not working in this mode.  |
|Exit from DFS | `ex` or `exit` | Exites from the DFS|

The client automatically connects to the Name Server. This servers should be located on the local network both. If one of the Storage Servers crashed, client ask from the Name Server new Storage Server and tries to work with DFS again.

##### Some technical issues

Client stores a local cache. This cache can store only 10 past files. The least recently used (**LRU**) cache algorithm controls a cache on the client.
All files get from Storage Server as a chunks (little parts of 512 kB).
Information about file is getting from the Name Server. 

---


#### Name Server by *Nikita Mokhnatkin*

For start up NS docker just run NSStart.sh that attached to report.
The name server sending UDP broadcast for finding a storage servers and clients.
Finding clients implemented for simplifying testing.  By the request of user server return set of numbers of chunks(for read or write) and ip addres of server. If Storage server is lost  then client get another server ID. Server's IDs grants by round-DNS principe.  for example:
the system have a two storage servers and 5 clients, then clients get the following server IDs:
| Client | Storage server id |
| :---: | :----------: |
|1|1|
|2|2|
|3|1|
|4|2|
|5|1|
A name server stored file system in MySQL database. Every connection(storage servers and clients) serviced by separate thread. 

Name server might be run several times for provide a robustness.
if one of the name servers will be lost then all clients and Storage servers relay to another name server.
#### Storage Server by *Sergey Grebennikov*
To run the **Storage Server** you need to type the following command in terminal:
```
$ sudo docker pull vkaser/dfs
$ sudo docker run -it storageserver
```
If you want to ensure data replication, you just need to start more than one storage server with previous command.

The Storage Server store files which are represented by chunks with a maximum size of 512 Kbytes.

More than one running storage server can provide fault tolerance. If one of them crashed, the others will continue to process requests.
