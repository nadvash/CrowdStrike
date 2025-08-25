Using CrowdStrike Soar to run Yara on all hosts.

This guide will show you how you can use CrowdStrike Soar to run Yara on your entire hosts, or on specific host group.

How does it work:

•	Create a On-demand workflow (can also be used with schedule and trigger)

•	Device query the desired host group that you want to run the Yara rule.

•	Running Yara using RTR

•	Using advanced event search to create correlation rules to alert if the Yara rule had any hits, (Can also build a dashboard instead of correlation rule).

 

Files needed to run the workflow, scripts will be provided:

•	Yara_Bundle.zip – Contain these 2 files, upload the zip to "put files" tab

  o	Yara64.exe – Yara binary
		
  o	Yara_Powershell.ps1 – PowerShell script that executes the Yara binary locally on the host
		
•	Launcher.bat – Bat file to run the PowerShell script so the Yara will run locally, upload this file into "put files" tab

•	Create_Yara_Powershell.ps1 – Creating the "yara_rule.yar" file in the host machine, Create this Script in the "Custom script" console.

•	Yara Run on Scale.yaml – the yaml of the workflow, import it to your console.



Where to upload the files:

•	Upload the Yara_Bundle.zip & launcher.bat to the "put files" tab in falcon console.

•	Create a custom PowerShell script using the content of the script "Create_Yara_Powershell.ps1"

•	Import the Json file into your workflows.


Full Soar workflow:
•	Run the on-demand workflow, you will only need to insert the "TargetScanPath" – where you want the Yara to run the scan.

•	Using device query, we filter out on what host groups we want to run the scan.

•	Scripts that start to run on each host –

o	1st we create the yara_rule.yar file, your Yara rule file.

o	Using the "put file" command we put the Yara_Bundle.zip to C:\Windows\Temp directory.

o	Using the launcher.bat script, we create a directory called "Yara", unzip the archive into the Yara directory, and move the yara_rule.yar file into Yara as well.

o	The launcher.bat also runs the PowerShell script locally on the host, while also transferring the "TargetScanPath" from the user input.

o	The PowerShell creates a .bat file with the hostname and the timestamp which contains information if there are any hits of the Yara scan.

o	The PowerShell then deletes all items in the directory except for the .bat file.

•	Send email about the workflow execution.

Correlation Rule/Dashboard query:

Using the query below you can create a correlation rule to notify your soc for further investigation, Or a dashboard widget for ongoing information.

#event_simpleName=ScriptFileWrittenInfo ScriptContent=* FileName="Yara*"

// Extract the part between 'echo' and '[]' as 'Rule Name'

| regex("echo\\s+(?<RuleName>[^\\[]+)", field=ScriptContent)

// Extract the path at the end of the log as 'Detection Path'

| regex("(?<DetectionPath>[A-Za-z]:\\\\[^\\s]+)$", field=ScriptContent)

// Display the extracted fields

| table([@timestamp,ComputerName,RuleName, DetectionPath])




*** To change the Yara rule you want to run, just edit the $YaraRule variable in the "Create_Yara_Powershell.ps1" in the falcon console.



