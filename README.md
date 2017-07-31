 **Work in progress!**
# Hyperledger Fabric and Hyperledger Composer on LinuxONE

## Architecture
![Flow Diagram](images/FlowDiagram.png)

This journey will guide you through the following process.

1. Requesting access to the LinuxONE Community Cloud.
2. Creating your Linux guest on the LinuxONE Community Cloud.
3. Setup and verification of your blockchain environment.
4. Creating a blockchain project in Hyperledger Composer.
5. Interacting with blockchain and third party APIs through Composer Rest Server and NodeRed.





## Application Overview
The blockchain workshop is intended to give you a basic understanding of how a developer would interact with Hyperledger Fabric using Hyperledger Composer. In this workshop you will use a browser based UI to modify chaincode, test your code and deploy your changes. You will also learn how tooling can take the code and generate API to allow for application integration through a REST-ful interface. 

This lab will be broken into three parts: 

1. Creating your guest and environment.
2. Writing chaincode and generating API.
3. Using NodeRed to test API integration.



## Workshop Instructions
### Scenario Overview
For this journey, we will simulate a thermostat and a temperature gauge to provide us temperature data. In a real world scenario, this could be a temperature sensor in your house or in an office building. The sensor could be connected to a real thermostat like Nest or other smart home devices via API. To keep family members, housemates, friends or children from excessively running air conditioning or heat, they must first find out if they have permission to adjust the thermostat by running a transaction defined in a smart contract running on Hyperledger Fabric. The contract will check the value recorded in the ledger for the temperature gauge to determine if their thermostat adjustment is environmentally friendly. Secondly, it will add integration to Weather.com to check current temperatures and adjust the thermostat to ideal settings based on the terms of the smart contract. 

### Part 1 - Setting up your LinuxONE Community Cloud guest

In this section of the journey you will request access to the LinuxONE Community Cloud, establish a SLES guest, run a setup script and verify the installation.

#### Request access to LinuxONE Community Cloud.

1. In a browser, go to https://developer.ibm.com/linuxone/ .

   ![LinuxONE Community Cloud Page](images/CommunityCloudPage.png)

2. **Click** *Start your trial now*.

   ![Click Start your trial now.](images/StartNow.png)

3. **Complete** the required fields on the page and **select** *Request your trial*.

   ![Complete application](images/GuestApplication.png)

4. You will come to the following page. **Click** *Sign In*.

   ![Click Sign In.](images/SignIn.png)

5. Check your email for a registration confirmation similar to the following shown. You'll need your User ID and Password from this email for the next step.

   ![Check your email for the registration confirmation email.](images/RegistrationConfirmationEmail.png)

   #### Create your LinuxONE guest

6. Back in your browser, **enter** the *user ID* and *password* from your email. **Click** *Sign in*.

   * Note: Now is a good time to change your password to one you'll remember. This can be done after the initial sign in by selecting your username from the upper right corner of the web page and selecting account settings.

   ![Sign in to LinuxONE Community Cloud.](images/SignInUserIDPW.png)

7. From the Home page of IBM LinuxONE Community Cloud, **select** *Manage Instances* on Virtual Servers under Infrastructure.

   ![Select Virtual Servers.](images/VirtualServers.png)

8. **Click** create.

   ![Click create.](images/Create.png)

9. Complete the following information:

   * Select *General purpose VM* for the type.

   * Enter an instance name — `DJBlockchain`

   * Enter an insance description — `Blockchain guest for Developers Journey.`

   * Select *SLES12 SP2* for the image.

   * Select *LinuxONE-Medium* for the flavor.

     ![Create your LinuxONE guest.](images/LinuxONEFields.png)

10. **Scroll down**. Under *Select a SSH Key Pair* **click** *create*.

 ![Click create.](images/CreateKeyPair.png)

11. In the pop-up dialog, **enter** the key name, `DJBlockchain` and **select** *Create a new key pair*.

    ![Enter a key name and select create.](images/KeyPairName.png)

12. Depending on your computer, you may receive a prompt asking you if you would like to save the new key pair. If so, choose to **Save File**.

    ![Click Save File.](images/SaveFile.png)

13. In the *Select a SSH Key Pair* box, **select** your newly create key pair, *DJBlockchain*.

    ![Select DJBlockchain.](images/SelectDJBlockchain.png)

14. Review the Current Selection information for accuracy and **click** *create* at the bottom of the screen to create your SLES 12 LinuxONE guest.

    ![Click create.](images/CreateGuest.png)

15. ​Watch the status of your newly create guest go through the following phases of start up:  networking :arrow_right: spawning :arrow_right: Active. When your guest shows active, it is ready for use.

    * *Note* — Write down the IP address of your guest. You'll need that for the next steps.

    ![Guest is ready!](images/StartedGuest.png)

16. From a terminal on your computer, navigate to the directory where you saved the SSH Key Pair, *DJBlockchain*. An example location is shown below.

    ![Download location example.](images/DownloadDirectory.png)


17. Modify the permissions of your private key by entering `chmod 600 DJBlockchain.pem`.

    ![Modify permissions.](images/SSHKeyPermissions.png)

18. From the location where your *DJBlockchain.pem* SSH key pair is, enter the command `ssh -i DJBlockchain.pem linux1@xxx.xxx.x.x` where the x's correspond to your Linux guest IP.

19. **Type** `yes` to the continue connecting prompt and **hit** the *enter* key.

    ![Type yes.](images/ContinueConnecting.png)

20. You are now connected into your IBM LinuxONE Community Cloud Guest!

    ![Success!](images/CommunityCloudWelcome.png)

    #### Setup your Linux guest for Hyperledger Fabric and Hyperledger Composer

21. Now it is time to setup your guest! Run the following command, to move the setup script from the Github Repository to your Linux guest.

    `wget https://raw.githubusercontent.com/IBM/HyperledgerFabric-on-LinuxOne/master/Linux1BlockchainScript.shW`

    ![Import script.](images/WgetSetup.png)

22. Enter `ls` to confirm the file is in your directory. 

    ![View script.](images/Linux1Script.png)

23. To make the file executable, run `chmod u+x Linux1BlockchainScript.sh` and then `ls` to make sure that it is showing as an executable file.

    ![Make the file executable.](images/Linux1ScriptExecutable.png)

24. Before running the script, you'll need to add your user id to the docker group. To do this, enter `sudo usermod -aG docker linux1` . To verify that the command worked, enter `docker` . Your output should look like the image below.

    ![Add user id to docker group.](images/AddIDtoDocker.png)

25. For this changes to take effect for the script, exit the ssh session by typing `exit`.

    ![Exit session.](images/ExitSession.png)

26. Log back in to your guest. `ssh -i DJBlockchain.pem linux1@xxx.xxx.x.x`where x is the values for your guest's IP address. (Refer to step 15 if you need help finding it.)

    ![Log back in to your guest.](images/ReLogin.png)

27. You're ready to run the setup script! Run the script using the following command, `./Linux1BlockchainScript.sh`. Be patient. It takes awhile!

    ![Run setup script.](images/RunSetupScript.png)

28. It's completed when the command line returns. It will look similar to the following image.

    ![Setup script is finished.](images/SetupScriptDone.png)

    #### Verify the installation of Hyperledger Fabric and Hyperledger Composer

29. To verify the installation, we will need to modify your .profile to be able to call newly installed packages. To do this type, `vi .profile`.

    ![Edit .profile](images/Editprofile.png)

30. To edit the .profile take the following actions:

    * Use the **arrow down key** to move the cursor to the last line of the file.

    * Use the **right arrow key** to move the cursor to the last letter of the file.

    * Type `i` to go into insert mode.

    * Hit **enter** twice to create two new lines.

    * Enter the following, `export PATH=/data/npm/bin:$PATH`

    * Hit **escape**.

    * Enter `:wq` and hit **enter** to save your changes.

      ![Edit your .profile.](images/ExportPathProfile.png)

31. For the changes to take place, exit your ssh session by typing `exit`.

    ![Exit session.](images/ExitSession.png)

32. Log back in to your guest. `ssh -i DJBlockchain.pem linux1@xxx.xxx.x.x`where x is the values for your guest's IP address. (Refer to step 15 if you need help finding it.)

    ![Log back in to your guest.](images/ReLogin.png)

33. To see if your blockchain network is up and running, use the command `docker ps -a`. You should see 4 containers with image names like the ones shown below.

    ![Running fabric containers.](images/RunningFabricContainers.png)

34. Verify that the composer command line interface and other tools were installed by entering `composer -v`.

    ![Verify Composer tools installation.](images/VerifyComposerCLI.png)

35. Verify Composer Playground is running by looking for its process using the command, `ps -ef|grep playground`. 

    ![Verify Composer Playground is running.](images/VerifyComposerPlaygroundRunning.png)

36. Open a browser and enter `xxx.xxx.x.x:8080` into the address bar where the x's correspond to your Linux guest's IP address. You should see the following:

    ![Loading Composer Playground.](images/ComposerPlaygroundUI1.png)

    ![Loaded Composer Playground.](images/ComposerPlaygroundUI2.png)

37. Congratulations! Part 1 is now complete! Lets get to work on the fun part. :smiley:


### Part 2 — Creating a blockchain application and generating API

#### Importing the components of your blockchain application

1. In a terminal on your computer, move to the home directory. `cd $HOME`

2. If not already installed, [install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git_) for your computer. 

3. Once Git is installed, run the following command to clone the needed materials for this exercise. `git clone https://github.com/IBM/HyperledgerFabric-on-LinuxOne.git`

   ![Clone GitHub repository](images/CloneGitHubRepo.png)

4. To find the files you'll need for this, `cd HyperledgerFabric-on-LinuxOne/code/` and then run `ls` to see what is in the directory.

   ![Move to code directory.](images/MoveToCodeDir.png)

5. Enter `pwd` to see where you are on your system. Save this information. You'll need it in a few steps.

   ![Enter pwd.](images/pwd.png)

6. Go back to your browser that has Composer Playground open. If you've closed it, you can open it in your browser by entering `xxx.xxx.x.x:8080` into the address bar where the x's correspond to your Linux guest's IP address.

   * **Note:** You will need to view the browser in Full Screen (fully expanded) mode to be able to access everything and prevent issues with inability to scroll on certain screens.

   ![View Composer Playground.](images/ComposerPlaygroundUI2.png)

7. Scroll down on the left side of the Composer Playground to select **Import/Replace**.


![Select Import/Replace](images/SelectImportReplace.png)




6. Select **Empty Business Network** and click **Deploy**.
   ![Click browse](images/EmptyBusinessNetwork.png)
7. From the _Import/Replace dialog window_, select **Replace & Import**.
   * **Note for Hyperledger Composer V0.7 - 0.9:** When you deploy your business network to Hyperledger Fabric, the business network name is used as the chaincode ID. If the business network name is changed then a new chaincode ID will be issued and used on deploy. All existing data in blockchain will be lost due to the change. We don't have to worry about that right now.


![Deploy bna file.](images/ReplaceImport.png)




9. Name your blockchain application. Select the **pencil** to edit the name and version. 

   ![Click the pencil icon.](images/ClickPencil.png)

10. Change the name and version to `blockchain-journey` and `1.0`.

 ![Name your blockchain application.](images/EditName.png)

11. Select **Add a File**.

    ![Select Add a File.](images/AddFile.png)

12. From the *Add a file* pop-up dialog, select **browse**.

    ![Select browse.](images/SelectBrowse.png)

13. In the file explorer window, navigate to where you downloaded the files. Refer to step 5 if you need help finding this location. **Select** *README.md* and **Click** *Open*.

    ![Select README.md](images/SelectREADME.png)

14. **Select** *Add*.

    ![Select Add.](images/AddREADME.png)

15. On the *Current definition will be replaced* dialog, **select** *Replace & Import*.

    ![Select Replace & Import.](images/READMEReplace.png)

16. Let's keep adding the files to the Composer Playground. **Select** *Add a file*.

    ![Select Add a file.](images/AddAFileREADME.png)

17. From the *Add a file* pop-up dialog, select **browse**.

    ![Select browse.](images/SelectBrowse.png)

18. In the file explorer window, navigate to where you downloaded the files. Refer to step 5 if you need help finding this location. Go into the *models* folder.  **Select** *org.acme.sample.cto* and **Click** *Open*. This is your model file that defines the assets, participants and transactions you'll use your in blockchain application.

    ![Select org.acme.sample.cto.](images/SelectModel.png)

19. Click **Add**. 

    ![Click Add.](images/AddModel.png)

20. **Select** *Add a file*.

    ![Select Add a file.](images/AddAFileREADME.png)

21. From the *Add a file* pop-up dialog, select **browse**.

    ![Select browse.](images/SelectBrowse.png)

22. In the file explorer window, navigate to where you downloaded the files. Refer to step 5 if you need help finding this location. **Select** *permissions.acl* and **Click** *Open*.

    ![Select permissions.acl.](images/SelectPermissions.png)

23. **Select** *Add*.

    ![Select Add.](images/AddPermissions.png)

24. **Select** *Add a file*.

    ![Select Add a file.](images/AddAFileREADME.png)

25. In the file explorer window, navigate to where you downloaded the files. Refer to step 5 if you need help finding this location. Go into the *lib* folder.  **Select** *logic.js* and **Click** *Open*. This is your JavaScript file that contains the logic for your model.

    ![Select logic.js.](images/SelectLogic.png)

26. **Select** *Add*.

    ![Select Add.](images/AddLogic.png)

27. Your files are all now loaded into Composer Playground. **Click** *Deploy* on the left side of the browser. 

    ![Click Deploy.](images/InitialDeploy.png)

    #### Creating your blockchain application

28. Click on **Model File**.

    ![Click Model File](images/SelectModelFile.png)

29. Click in the **editor** on the right to begin writing your models. 

    * NOTE: **DO** **NOT** modify the namespace during the lab.

      ![Click in the editor](images/ClickEditor.png)

30. On a new line, give your asset `Sensor` the following attributes.

    * Note: a small "o" is used as a bullet in the model.

    * `o String teamID` — this will be the value that is assigned to your team. (already there!)

    * `o String teamName`— this could be anything! Come up with something clever!

    * `o Double sensorTemp` — temperature from the Raspberry Pi will be stored here.

    * `o Double thermostatTemp`— you will create a temperature for the thermostat.

    * `o String recommendation`— this will be populated based on the `CompareWeather` transaction.

    * **Click** *Deploy* to save changes.

      ![Sensor model](images/SensorModel.png)

31. Now create your first transaction model for `SetSensorTemp`. Enter the following attributes:

    * `--> Sensor gauge` — The transaction will need to put data into the `Sensor` asset. This passes a reference to the asset so we can work with the asset in the logic for the transaction.

    * `o Double newSensorValue` — This is the variable that will be set by the temperature passed into the transaction from the NodeRed Sensor for picking up temperature.

    * *Click** *Deploy* to save changes.

      ![Create SetSensorTemp model](images/SetSensorTempModel.png)

32. Build your `ChangeThermostatTemp` transaction model. Add the following:

    * `--> Sensor thermostat` — The transaction will need to put data into the `Sensor` asset for the thermostat. This passes a reference to the asset so we can work with the asset in the logic for the transaction.

    * `o Double newThermostatValue` — This allows for a new, proposed value to be sent into the transaction. In the logic tab, we will use this value to compare to what the gauge says and decide if the thermostat value should be adjusted.

    * *Click** *Deploy* to save changes.

      ![Create ChangeThermostatTemp model](images/ChangeThermostatModel.png)

33. Enter the following values to build your `CompareWeather` transaction model:

    * `--> Sensor recommend` — The transaction will need to put data into the `Sensor` asset. This passes a reference to the asset so we can work with the asset in the logic for the transaction.
    * `o Double outsideTemp` — Looking at the [Weather.com API](https://twcservice.eu-gb.mybluemix.net/rest-api/#!/Current_Conditions/v1locobscurrent) for Current Conditions, you can see all of the possible data that the call could return. Based on the data, it was decided to take the actual outside temperature and the feels like temperature to give a recommendation on thermostat settings. This variable stores the value passed into it via NodeRed from Weather.com for the outside temperature.  The model on the API page shows up whether the data is returned in Celsius or Fahrenheit and its variable type. In this exercise we will use Celsius.

    ![Weater.com API temps](images/Part1_Step16Temps.png)

    * `o Double feelsLike`— the variable to store the feels_like value from Weather.com.

    * **Click** *Deploy* to save changes.

      ![create CompareWeather model](images/CompareWeatherModel.png)

34. Click on the **Script File** tab.


![Click Script File](images/ClickScriptFile.png)



35. **Review the code in the editor. **Verify that your variable names match the variable names here.  Capitalization does matter! If names don't match, you'll have errors. 

    * Any guesses what the code is doing for each transaction?

      ![Review code](images/ReviewScriptFile.png)

    #### Test application code

36. Click on the **Test** tab at the top to try out your code.

![Click Test](images/ClickTest.png)

37. Notice that in this particular case because we have no participants, the **Test** tab has opened to the **Asset** menu on the left. You must have an asset to be able to run any of the transactions.

    * Click **Create New Asset**.

      ![Click Create New Asset](images/CreateNewAsset.png)

38. Create an example asset to test your code by filling in the following information:

   * `"teamID": "teamID:**xxx**"` where ** **xxx** ** is any team number you'd like.

   * `"teamName":""` — this could be any name you'd like. Be clever! :bowtie:

   * `"sensorTemp": **0**` — Set ** **0** ** to any value. When you work with NodeRed, temperatures will be in Celsius.

   * `"thermostatTemp": **0** `— Set ** **0** ** to any value. This is initializing your thermostat so pick a value you want to work with.

   * `"recommendation": "" `— Leave this as is.

   * *Make a note somewhere** of the values you used for `sensorTemp` and `thermostatTemp`.

     ![Create asset](images/NewAssetValues.png)

39. Click **Create New**.

   ![Click Create New](images/ClickCreateNew.png)

40. Once your **Team** asset is created it should show in the registry as shown below.

    ![Asset registry](images/Team01Asset.png)

41. You're ready to run your first transaction. **Click** on *Submit Transaction*.

    ![Click Submit Transaction](images/ClickSubmitTransaction.png)

42. The **Submit Transaction** dialog will open a new window. 

    * Make sure that the **Transaction Type** is set to `SetSensorTemp`.

    * Modify the JSON data`"asset": "resource:org.acme.sample.Team#teamID:xxx"`  — enter your team's identifier in place of the value where **xxx** is in the sample JSON data.

    * Modify the JSON data`"newSensorValue": 0` — enter a value your sensor could have.

    * Click **Submit**.

      ![Submit SetSensorTemp](images/SetSensorTempTran.png)

43. If you submitted the transaction with your correct team ID, then you should have a transaction showing in your registry with the data you entered in the prior step. Congratulations! You've now completed a transaction. :thumbsup:

    ![Transaction Registry](images/TransactionRegistry.png)

44. Verify that `SetSensorTemp` updated the `sensorTemp`value in your asset. Click **Sensor**.

    ![Click Team](images/ClickSensor.png)

45. Check the `sensorTemp` value. Does it have the new value from the `SetSensorTemp` transaction?

    ![Check sensorTemp value](images/VerifySensorTemp.png)

46. Let's do another transaction. Select **Submit Transaction**.

    ![Select Submit Transaction](images/SubmitTransaction2.png)

47. This time let's run, `ChangeThermostatTemp`. 

   * In the **Transaction Type** drop down, select `ChangeThermostatTemp`.
     ![Select ChangeThermostatTemp](images/SelectChangeThermostat.png)

   * Edit the sample JSON for the transaction`"asset": "resource:org.acme.sample.Team#teamID:xxx"`— change **xxx** to your team ID value.

   * Edit the sample JSON for the transaction`"newThermostatValue": 0` — Replace **0** with a value to which you would like to see if you can adjust the thermostat.

   * Click **Submit**.

     ![Submit ChangeThermostatTemp](images/ChangeThermostatTran.png)

   * If you select a temperature for the thermostat that is not within 3 degrees of the `sensorTemp` value, then you will get an error message like the one below. If you get this message, enter another value and click submit.

     ![ChangeThermostatTemp Error Message](images/Errormsg.png)

   * If you do have permission to adjust the thermostat, you will be returned back to the transaction registry where you can see the data you just submitted.

     ![Successful Transaction](images/TransactionRegistry2.png)

   * If for some reason you forget to modify your teamID value or update it to the wrong value, you will see an error like the one shown below. Check your value for teamID and try again.

     ![Asset does not exist error message](images/TeamIDError.png)

48. Verify that the last transaction updated your asset. Click **Sensor**.

    ![Click Sensor](images/ClickSensor2.png)

49. Verify that the `thermostatTemp` attribute for your Team has been updated to the value you gave successsfully in the `ChangeThermostatTemp` transaction.

    * **Note**: In step 40, you can verify that the thermostat was originally set to 20 and is now set to 16.

      ![Verify thermostatTemp value](images/VerifyThermostatTemp.png)

50. Time to work with the `CompareWeather` transaction. Click **Submit Transaction**.

    ![Click Submit Transaction](images/SubmitTransaction3.png)

51. Select **CompareWeather** from the *Transaction Type* drop down.

    ![Select CompareWeather](images/Part1_Step36.png)

52. Complete the **CompareWeather** transaction.

    * Modify the JSON, `"asset": "resource:org.acme.sample.Team#teamID:xxx"`— Replace **xxx** with your team ID.

    * Modify the JSON for`"outsideTemp": 0`— Enter a value for an outside temperature.

    * Edit the JSON for`"feelsLike": 0` — Enter a value for what temperature it could feel like outside.

    * Click **Submit**.

      ![Complete CompareWeather](images/CompareWeatherTran.png)

53. Verify that your transaction is showing in the Transaction Registry.

    ![Transaction Registry](images/TransactionRegistry3.png)

54. Click on **Sensor**. 

    ![Click Sensor](images/ClickSensor3.png)

55. Verify there is now a message in the `recommendation`variable in your Team asset and that the `thermostatValue` has been updated to the recommended value.

    ![Team asset recommendation value](images/VerifyRecommendation.png)

56. Continue testing your code for all scenarios to understand what your contract(s) can do. The hints to the remaining scenarios are as follows: (Yes, you'll have to look at the Script File under the Define Tab to figure out the criteria.)

    * ChangeThemostatTemp:
      - [ ] A successful transaction where the `thermostatValue` is updated in the Sensor asset.
      - [ ] An error message in the *Submit Transaction* window advising you do not have permission to adjust the thermostat.
    * CompareWeather:
      - [ ] A transaction based on `outsideTemp` values where it is really hot.
      - [ ] A transaction based on `outsideTemp` values where it is quite nice.
      - [ ] A transaction based on `outsideTemp` values where it is cold.
      - [ ] A transaction based on `feelsLike` values where it hot.
      - [ ] A transaction based on `feelsLike` values where it is quite nice.
      - [ ] A transaction based on `feelsLike` values where it is cold.

    * **Note:** You should verify that your asset values have been updated appropriately after each transaction like you did in prior steps.


#### Deploy application to Hyperledger Fabric

57. In your terminal connected to your Linux guest, enter the command `cd ~/.composer-connection-profiles/`. Enter `ls` to see the profiles in the directory. The profile was created during the setup script. You'll need the information in it to connect Hyperledger Composer to Hyperledger Fabric.

    ![View your connection profiles.](images/ComposerConnectionProfile.png)

58. Move into the profile directory, `cd hlfv1` and view the file in it by doing `cat connection.json`. Keep the terminal available, you'll need to view this information in just a second.

    ![View connection.json](images/ConnectionJSON.png)

59. Back in your browser where Hyperledger Composer Playground is running, **click** the *Define* tab and then **click** *Export* to save your code to your desktop. This is a safety measure. Export saves all of the indivudual files we imported at the beginning of Part 2 into a compressed file called a business network archive (.bna).

    ![Click Export](images/ClickExport.png)

60. In the pop-up dialog, **click** *Save File*.

    ![Click Save File.](images/SaveFile2.png)

61. In the upper right corner of your browser, **select** the *globe icon*.

    ![Select the globe icon.](images/globe.png)

62. **Select** *Import or Create a Profile*.

    ![Select Import or Create a Profile.](images/ImportProfile.png)

63. On the *Import/Create a Connection Profile* dialog, **select** *Hyperledger Fabric v1.0* and **click** *Add*.

    ![Select Hyperledger Fabric v1.0.](images/SelectHFv1.png)

64. Complete the following fields according to the information in your connection.json on the Linux guest. This is in your terminal as found in step 58.**Information for Orderer, Channel, MSP ID, CA, Peers and Key Value Store must be exact.**

    * Connection Profile — LinuxONECC

    * Orderer(s) — `grpc://localhost:7050`

    * Channel — `composerchannel`

    * MSP ID — `Org1MSP`

    * CA — `http://localhost:7054`

    * Peer(s) — `grpc://localhost:7051`, `grpc://localhost:7053`

    * Key Value Store — `/home/linux1/.composer-credentials`

    * **Click** *Save*.

      ![Enter the information in the Composer Playground Profile.](images/PlaygroundConnectionProfile.png)

65. **Click** *Use this profile*.

    ![Click Use this profile.](images/UseThisProfile.png)

66. In the *Connect with an identity* window, **click** *Add identity*.

    ![Click Add identity.](images/AddIdentity.png)

67. Create a User ID of `PeerAdmin` and a User Secret of `linux`. The User ID must be PeerAdmin but the User Secret could be anything.**Click** *Connect*.

    ![Fill in the identity values.](images/PeerAdmin.png)

68. When the Composer Playground has successfully connected to your Hyperledger Fabric, you will see the following in your browser.

    ![Connected to Hyperledger Fabric.](images/ConnectedToFabric.png)

69. Back in your terminal, enter `docker ps -a` . You can see there is now a new container running where Composer Playground has deployed code to the Hyperledger Fabric.

    ![View Hyperledger Composer Playground container.](images/PlaygroundContainer.png)

70. Switch back to your Hyperledger Composer Playground browser, **click** *Define* and then **select** *About*.

    ![Click Define and About.](images/DefineConnectedPlayground.png)

71. Notice that there is now a basic-sample-network application showing and not your blockchain-journey. We will need to import it to deploy it to the Hyperledger Fabric. **Select** *Import/Replace*.

    ![Select Import/Replace.](images/SelectImport.png)

72. In the *Import/Replace Business Network* window, **select** *browse.*

    ![Select browse.](images/SelectBrowse2.png)

73. In the file explorer window, **navigate** to where you downloaded `blockchain-journey.bna`. **Select** *blockchain-journey.bna* and **click** *Open*.

    ![Select your bna file and click open.](images/ImportBNA.png)

74. **Click** *Deploy* in the *Import/Replace Business Network* dialog to deploy your blockchain application to Hyperledger Fabric.

    ![Click Deploy.](images/DeployBNA.png)

75. In the warning window, *Current definition will be replaced*, **click** *Replace & Import*.

    ![Click Replace & Import.](images/ReplaceImportBNA.png)

76. You should see your blockchain-journey in the Hyperledger Composer Playground when it is successfully deployed. Congratulations! You've deployed your first blockchain application to Hyperledger Fabric.

    * **Note:** As a safety measure, check the Model File and Script File to make sure your code is there. It is also good practice to run some transaction in the test tab.

    ![Successful deployment.](images/SuccessfulDeployBNA.png)

    #### Generating API

77. In your terminal, you'll need to edit your hosts file. 

    * `sudo vi /etc/hosts`

    * Enter `i` to begin insert mode.

    * Use your arrow keys to move to the end of the line that has `127.0.0.1       localhost`

    * Press `Enter` to start a new line.

    * On the new line, type in `xxx.xxx.x.x     djblockchain` where the x's is the IP address for your Linux guest.

    * Press `Esc` to leave insert mode.

    * Enter `:wq` to save your changes.

      ![Edit your hosts file.](images/Hosts.png)

78. In your terminal, issue the following commands to start the API rest server:

    *  `mkdir /data/linux1/playground`

    * `nohup composer-rest-server -p hlfv1 -n org-acme-biznet -i PeerAdmin -s linux -N always >/data/linux1/playground/rest.stdout 2>/data/linux1/playground/rest.stderr & disown`

      ![Start your API rest server.](images/StartRestServer.png)

79. Verify the rest server process is running. `ps -ef|grep rest`

    ![Verify the rest server is running.](images/VerifyRestServer.png)

80. To see your API, go back to your browser and open a new tab or window. In the address bar, enter `http://xxx.xxx.x.x:3000/explorer` where the x's are the IP address for your Linux guest. You should see a page like the one shown.

    ![View your REST APIs.](images/RestAPI.png)

81. Expand the different methods to see the various calls and parameters you can make through REST API. You can also test the API in this browser to learn how to form the API and see the responses.

    ![Test your API.](images/TestAPI.png)

82. Congratulations! You now have a working blockchain application and have created APIs to call your blockchain application.

    ​



### End of Part 2



###Part 3 — Utilizing blockchain API through NodeRED 



#### Importing your flow into NodeRED
1. Open NodeRED in your browser in a new tab or window. Enter `http://127.0.01:1880` in the address bar.

   ![Open NodeRED.](images/OpenNodeRED.png)

2. Copy the JSON below.
```JSON
[
    {
        "id": "f3ea0c80.1744b",
        "type": "tab",
        "label": "Flow 1"
    },
    {
        "id": "72360b12.36f004",
        "type": "ui_group",
        "z": "",
        "name": "Blockchain",
        "tab": "2a876f19.0af568",
        "order": 2,
        "disp": true,
        "width": "6"
    },
    {
        "id": "64c77f08.17e9c8",
        "type": "ui_group",
        "z": "",
        "name": "Thermostat",
        "tab": "2a876f19.0af568",
        "order": 4,
        "disp": true,
        "width": "6"
    },
    {
        "id": "2a876f19.0af568",
        "type": "ui_tab",
        "z": "",
        "name": "Home",
        "icon": "dashboard",
        "order": 2
    },
    {
        "id": "f644913a.10cd98",
        "type": "ui_base",
        "theme": {
            "name": "theme-light",
            "lightTheme": {
                "default": "#0094CE",
                "baseColor": "#0094CE",
                "baseFont": "-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen-Sans,Ubuntu,Cantarell,Helvetica Neue,sans-serif",
                "edited": true,
                "reset": false
            },
            "darkTheme": {
                "default": "#097479",
                "baseColor": "#097479",
                "baseFont": "-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen-Sans,Ubuntu,Cantarell,Helvetica Neue,sans-serif",
                "edited": false
            },
            "customTheme": {
                "name": "Untitled Theme 1",
                "default": "#4B7930",
                "baseColor": "#4B7930",
                "baseFont": "-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen-Sans,Ubuntu,Cantarell,Helvetica Neue,sans-serif"
            },
            "themeState": {
                "base-color": {
                    "default": "#0094CE",
                    "value": "#0094CE",
                    "edited": false
                },
                "page-titlebar-backgroundColor": {
                    "value": "#0094CE",
                    "edited": false
                },
                "page-backgroundColor": {
                    "value": "#fafafa",
                    "edited": false
                },
                "page-sidebar-backgroundColor": {
                    "value": "#ffffff",
                    "edited": false
                },
                "group-textColor": {
                    "value": "#1bbfff",
                    "edited": false
                },
                "group-borderColor": {
                    "value": "#ffffff",
                    "edited": false
                },
                "group-backgroundColor": {
                    "value": "#ffffff",
                    "edited": false
                },
                "widget-textColor": {
                    "value": "#111111",
                    "edited": false
                },
                "widget-backgroundColor": {
                    "value": "#0094ce",
                    "edited": false
                },
                "widget-borderColor": {
                    "value": "#ffffff",
                    "edited": false
                },
                "base-font": {
                    "value": "-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen-Sans,Ubuntu,Cantarell,Helvetica Neue,sans-serif"
                }
            }
        },
        "site": {
            "name": "Node-RED Dashboard",
            "hideToolbar": "false",
            "allowSwipe": "false",
            "dateFormat": "DD/MM/YYYY",
            "sizes": {
                "sx": 48,
                "sy": 48,
                "gx": 6,
                "gy": 6,
                "cx": 6,
                "cy": 6,
                "px": 0,
                "py": 0
            }
        }
    },
    {
        "id": "94ef22f.e91a56",
        "type": "ui_group",
        "z": "",
        "name": "Blockchain",
        "tab": "5019005c.024db",
        "order": 2,
        "disp": true,
        "width": "6"
    },
    {
        "id": "5329fc38.f9991c",
        "type": "ui_group",
        "z": "",
        "name": "Thermostat",
        "tab": "5019005c.024db",
        "order": 4,
        "disp": true,
        "width": "6"
    },
    {
        "id": "5019005c.024db",
        "type": "ui_tab",
        "z": "",
        "name": "Home",
        "icon": "dashboard",
        "order": 2
    },
    {
        "id": "1ee0cb15.d216fd",
        "type": "http request",
        "z": "f3ea0c80.1744b",
        "name": "Add Block",
        "method": "POST",
        "ret": "obj",
        "url": "http://148.100.5.9:3000/api/org.acme.sample.SetSensorTemp",
        "tls": "",
        "x": 1250,
        "y": 440,
        "wires": [
            [
                "fdc93bd.b1faec8"
            ]
        ]
    },
    {
        "id": "e1dcc27a.7ea0c",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain",
        "func": "d = msg.payload.d.temperature;\ntid = global.get('teamName');\ntime = new Date().toISOString();\nmsg.payload = {\n \"$class\": \"org.acme.sample.SetSensorTemp\",\n  \"gauge\": \"resource:org.acme.sample.Sensor#teamid:\"+tid,\n  \"newSensorValue\": d,\n  \"timestamp\": time\n};\nreturn msg;\n",
        "outputs": 1,
        "noerr": 0,
        "x": 1016.9999914169312,
        "y": 439.00001525878906,
        "wires": [
            [
                "1ee0cb15.d216fd"
            ]
        ]
    },
    {
        "id": "3b2660c5.3445d8",
        "type": "ui_text_input",
        "z": "f3ea0c80.1744b",
        "name": "",
        "label": "TeamName",
        "group": "94ef22f.e91a56",
        "order": 1,
        "width": "6",
        "height": "1",
        "passthru": true,
        "mode": "text",
        "delay": "500",
        "topic": "",
        "x": 1103.6666526794434,
        "y": 599.0000152587891,
        "wires": [
            [
                "dbdefdbf.3d12a"
            ]
        ]
    },
    {
        "id": "b2f61a15.a3ddc",
        "type": "http request",
        "z": "f3ea0c80.1744b",
        "name": "Set Team Name",
        "method": "POST",
        "ret": "obj",
        "url": "http://148.100.5.9:3000/api/org.acme.sample.Sensor",
        "tls": "",
        "x": 1402.0555572509766,
        "y": 764.222240447998,
        "wires": [
            [
                "8a6646ff.a445c"
            ]
        ]
    },
    {
        "id": "dbdefdbf.3d12a",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "setTeamname",
        "func": "n = msg.payload;\nglobal.set('teamName',n);\n\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1320.6666526794434,
        "y": 600.0000152587891,
        "wires": [
            []
        ]
    },
    {
        "id": "357f3aac.675316",
        "type": "weather_insights",
        "z": "f3ea0c80.1744b",
        "name": "Current Weather",
        "host": "twcservice.mybluemix.net",
        "service": "/observations.json",
        "geocode": "",
        "units": "m",
        "language": "",
        "x": 1191.6666526794434,
        "y": 863.0000152587891,
        "wires": [
            [
                "b9afd5dd.013f4"
            ]
        ]
    },
    {
        "id": "37d857f1.716798",
        "type": "inject",
        "z": "f3ea0c80.1744b",
        "name": "",
        "topic": "",
        "payload": "41.8585185,-88.372492",
        "payloadType": "str",
        "repeat": "240",
        "crontab": "",
        "once": true,
        "x": 903.777759552002,
        "y": 862.9999828338623,
        "wires": [
            [
                "357f3aac.675316"
            ]
        ]
    },
    {
        "id": "bca4bf31.a7b478",
        "type": "ui_button",
        "z": "f3ea0c80.1744b",
        "name": "",
        "group": "5329fc38.f9991c",
        "order": 7,
        "width": 0,
        "height": 0,
        "passthru": false,
        "label": "Change Thermostat",
        "color": "Light Blue",
        "bgcolor": "",
        "icon": "",
        "payload": "",
        "payloadType": "str",
        "topic": "",
        "x": 880.6666526794434,
        "y": 988.0000152587891,
        "wires": [
            [
                "8c84f9d0.2f793"
            ]
        ]
    },
    {
        "id": "8c84f9d0.2f793",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "ChangeThermo",
        "func": "tid = global.get('teamName');\ntime = new Date().toISOString();\nthermo = global.get('TempThermostat');\nasset = \"resource:org.acme.sample.Sensor#teamid:\"+tid,\n\nmsg.payload = {\n  \"$class\": \"org.acme.sample.ChangeThermostatTemp\",\n   \"thermostat\": asset,\n  \"newThermostatValue\": thermo,\n  \"timestamp\": time\n}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1198.6666526794434,
        "y": 990.0000152587891,
        "wires": [
            [
                "16e10f0c.cc5d21"
            ]
        ]
    },
    {
        "id": "16e10f0c.cc5d21",
        "type": "http request",
        "z": "f3ea0c80.1744b",
        "name": "Change Thermostat",
        "method": "POST",
        "ret": "obj",
        "url": "http://148.100.5.9:3000/api/org.acme.sample.ChangeThermostatTemp",
        "tls": "",
        "x": 1526.5555610656738,
        "y": 993.1111326217651,
        "wires": [
            [
                "9e89c128.5ce5e8"
            ]
        ]
    },
    {
        "id": "72072298.80512c",
        "type": "ui_button",
        "z": "f3ea0c80.1744b",
        "name": "",
        "group": "94ef22f.e91a56",
        "order": 5,
        "width": "6",
        "height": "1",
        "passthru": false,
        "label": "Get Recommendation",
        "color": "",
        "bgcolor": "",
        "icon": "",
        "payload": "",
        "payloadType": "str",
        "topic": "",
        "x": 955.4444274902344,
        "y": 1182.5556106567383,
        "wires": [
            [
                "cd4b47f0.68b88"
            ]
        ]
    },
    {
        "id": "cd4b47f0.68b88",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "getRecommendation",
        "func": "tid = global.get('teamName');\ntime = new Date().toISOString();\nweather = global.get('weather-observation');\nasset = \"resource:org.acme.sample.Sensor#teamid:\"+tid,\ntransid = global.get('lastTransID');\nmsg.payload = {\n  \"$class\": \"org.acme.sample.CompareWeather\",\n  \"transactionId\": transid,\n  \"recommend\": asset,\n  \"outsideTemp\": weather.temp,\n  \"feelsLike\": weather.feels_like,\n  \"timestamp\": time\n}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1199.4444274902344,
        "y": 1182.5556106567383,
        "wires": [
            [
                "ac2491e2.1c61"
            ]
        ]
    },
    {
        "id": "ac2491e2.1c61",
        "type": "http request",
        "z": "f3ea0c80.1744b",
        "name": "CompareWeather",
        "method": "POST",
        "ret": "obj",
        "url": "http://148.100.5.9:3000/api/org.acme.sample.CompareWeather",
        "tls": "",
        "x": 1439.4444274902344,
        "y": 1182.5556106567383,
        "wires": [
            [
                "e4eedce1.caf208",
                "96e13e95.d5eec"
            ]
        ]
    },
    {
        "id": "e4eedce1.caf208",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "getTeamID",
        "func": "team = global.get('teamName');\nmsg = {};\nmsg.topic = \"teamid%3A\"+team;\n\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1658.4444274902344,
        "y": 1182.5556106567383,
        "wires": [
            [
                "875cf191.ec81c8"
            ]
        ]
    },
    {
        "id": "875cf191.ec81c8",
        "type": "http request",
        "z": "f3ea0c80.1744b",
        "name": "",
        "method": "GET",
        "ret": "obj",
        "url": "http://148.100.5.9:3000/api/org.acme.sample.Sensor/{{{topic}}}",
        "tls": "",
        "x": 1852.4444274902344,
        "y": 1182.5556106567383,
        "wires": [
            [
                "8c856891.dc0958"
            ]
        ]
    },
    {
        "id": "31763e62.54f792",
        "type": "ui_toast",
        "z": "f3ea0c80.1744b",
        "position": "dialog",
        "displayTime": "3",
        "highlight": "",
        "outputs": 1,
        "ok": "OK",
        "cancel": "",
        "topic": "",
        "name": "",
        "x": 1408.6666526794434,
        "y": 681.0000152587891,
        "wires": [
            []
        ]
    },
    {
        "id": "8058ff8a.6deb38",
        "type": "inject",
        "z": "f3ea0c80.1744b",
        "name": "check team name",
        "topic": "Team Name is not set. Please add your team name and press the add team name button",
        "payload": "",
        "payloadType": "date",
        "repeat": "",
        "crontab": "",
        "once": true,
        "x": 835.6666526794434,
        "y": 694.0000152587891,
        "wires": [
            [
                "1f2a526e.47de7e",
                "116a49b5.5ee9ee"
            ]
        ]
    },
    {
        "id": "1f2a526e.47de7e",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "locatedTeamName",
        "func": "team = global.get(\"teamName\");\nif (team){\n    msg.topic=\"Team Name is set\"\n    msg.payload = team;\n}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1190.6666526794434,
        "y": 680.0000152587891,
        "wires": [
            [
                "31763e62.54f792"
            ]
        ]
    },
    {
        "id": "dba6e20f.7a613",
        "type": "ui_button",
        "z": "f3ea0c80.1744b",
        "name": "",
        "group": "94ef22f.e91a56",
        "order": 2,
        "width": "6",
        "height": "1",
        "passthru": false,
        "label": "Add Team Name",
        "color": "",
        "bgcolor": "",
        "icon": "",
        "payload": "",
        "payloadType": "str",
        "topic": "",
        "x": 879.6666526794434,
        "y": 764.0000152587891,
        "wires": [
            [
                "5335d93.10223a8"
            ]
        ]
    },
    {
        "id": "5335d93.10223a8",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "getTeamName",
        "func": "\nn = global.get('teamName');\nmsg.payload = {\n  \"$class\": \"org.acme.sample.Sensor\",\n  \"teamID\": \"teamid:\"+n,\n  \"teamName\": n,\n  \"sensorTemp\":0,\n  \"thermostatTemp\":0,\n  \"recommendation\":\"none\"\n};\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 1136.1666450500488,
        "y": 764.5555877685547,
        "wires": [
            [
                "b2f61a15.a3ddc"
            ]
        ]
    },
    {
        "id": "116a49b5.5ee9ee",
        "type": "function",
        "z": "f3ea0c80.1744b",
        "name": "Find Team Name",
        "func": "n = global.get('teamName');\nif (n){\n    msg.payload = n;\n}else{\n    msg.payload=\"Please Add Team Name\";\n}\nreturn msg;",
        "outputs": 1,
        "noerr": 0,
        "x": 878.6666526794434,
        "y": 602.0000152587891,
        "wires": [
            [
                "3b2660c5.3445d8"
            ]
        ]
    },
    {
        "id": "e2f25876.c3415",
        "type": "ui_text",
        "z": "f3ea0c80.1744b",
        "group": "94ef22f.e91a56",
        "order": 4,
        "width": "6",
        "height": "1",
        "name": "",
        "label": "Ask Block Chain for Recommendation",
        "format": "{{msg.payload}}",
        "layout": "row-left",
        "x": 928.6666526794434,
        "y": 1093.000015258789,
        "wires": []
    },
    {
        "id": "b9afd5dd.013f4",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Weather",
        "links": [
            "1e684a8f.b97ac5",
            "30a06d42.4fc062"
        ],
        "x": 1362.7222633361816,
        "y": 864.2222185134888,
        "wires": []
    },
    {
        "id": "fdc93bd.b1faec8",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain add block",
        "links": [
            "26579818.2a28c8"
        ],
        "x": 1449.277696609497,
        "y": 440.00000381469727,
        "wires": []
    },
    {
        "id": "8a6646ff.a445c",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain - teamname",
        "links": [
            "26579818.2a28c8",
            "95f66de6.73289"
        ],
        "x": 1566.6110944747925,
        "y": 763.11106300354,
        "wires": []
    },
    {
        "id": "9e89c128.5ce5e8",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain change thermo",
        "links": [
            "26579818.2a28c8",
            "691d8fae.cc6dd"
        ],
        "x": 1694.3888502120972,
        "y": 994.2221832275391,
        "wires": []
    },
    {
        "id": "96e13e95.d5eec",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain Compare",
        "links": [
            "26579818.2a28c8"
        ],
        "x": 1567.7221946716309,
        "y": 1275.333267211914,
        "wires": []
    },
    {
        "id": "8c856891.dc0958",
        "type": "link out",
        "z": "f3ea0c80.1744b",
        "name": "Blockchain recommendation",
        "links": [
            "26579818.2a28c8",
            "34c327fb.be62a8"
        ],
        "x": 1981.0554466247559,
        "y": 1264.222183227539,
        "wires": []
    },
    {
        "id": "9f49e55a.8ff408",
        "type": "link in",
        "z": "f3ea0c80.1744b",
        "name": "IoT Event - Temperature",
        "links": [
            "2dcfad9.1e84952",
            "f8160c87.24af3"
        ],
        "x": 804.3333511352539,
        "y": 439.3333339691162,
        "wires": [
            [
                "e1dcc27a.7ea0c"
            ]
        ]
    }
]
```
3. Paste it into NodeRed, by **clicking** on the *menu icon* in the upper right corner.

   ![menu](images/node-red-menu.png)

4. **Select** *Import -> Clipboard*.

   ![menu](images/node-red-menu-import-clipboard.png)

5. **Paste** the code in the editor. Make sure to **select** "current flow" button. **Select** *Import*.

   ![import editor](images/node-red-menu-import-editor.png)

6. You should now have a new flow with the label of "Blockchain".

   #### Modifying your flow to call your API

7. We now need to modify the API calls to call your Linux guest.


2. Update Bluemix IoT Flow

We are now going to update the link node on the "Bluemix IoT Flow" tab. Remember, previously we updated the link node to send updates to the dashboard. Now we are going to also have the "Iot Environment" events sent to the newly created "Blockchain" flow.

![link node](images/iot-flow-link-node.png)

We do this by double clicking on the **Link Node**. 

![link node](images/iot-flow-link-node-editor.png)

Make sure all three check boxes are checked. "IoT Event - Temperature" is the new box that needs to be checked. This will send the IoT events to the Blockchain flow.

3. Update Weather Insight node

Double click on the **Current weather** node.

![current weather node](images/blockchain-flow-currentweather-node.png)

You should now see the node editor for the weather insights node.

![current weather node editor](images/blockchain-flow-currentweather-node-editor.png)

Similarly like with the hybrid lab, you need to paste your username and password in to the appropriate fields. Also make sure the **service** is "Current Observations".
You can click **Done** when completed.

4. Deploy the changes by clicking ont the **Deploy** button.
   ![deploy button](images/blockchain-flow-deploy-button.png)

5. Go to the Dashboard page

You should see that data is now flowing to all of the widgets on the dashboard page. Though you will see some error messages. This is because we have to register with blockchain your team name. If you remember from the lab, you need to create a new "Team Asset". 

We do this by typing our team name in the entry field and then clicking on **Add Team Name** button.

![add team button](images/dashboard-add-team-button.png)

You should see a status message indicate the team name was added successfully.

![deploy button](images/dashboard-status-team-added.png)

Now your IoT events are will be added to blockchain under your asset name. You should see the counter for blocks increment as your IoT events are being sent.
This is important, because, in the next steps we are going to validate try to make some changes and blockchain will help in the process.

6. Change the Thermostat

In this step we are going to change the value of the "Thermostat". The way you do this is by clicking on the **Thermostat Value** slider and move it. 

![thermo slider](images/dashboard-thermo-slider.png)

You will notice as you change the slide, the "Thermostat" gauge underneath it also changes. 
Move the slider to any value you choose. Once you are comfortable with your choice you can 
send a request to blockchain, to determine if your choice is valid, based on the blockchain contract. 
This is done by clicking the **Change Thermostat** button.

![change thermo button](images/dashboard-changethermo-button.png)

Now depending on the value you chose, your temperature my be allowed, or reset to its prior value.
The logic within blockchain is to allow the thermostat to be within plus/minus three degrees of
your last stored temperature block. So look at your "ense Hat Temperature" value on the screen 
and then change your thermostat to be within the allowed value range.

**Invalid Change**
![change thermo bad](images/dashboard-change-thermo-bad.png)


**Valid Change**
![change thermo good](images/dashboard-change-thermo-good.png)

7. Blockchain Recommendation

In this last step we are sending a request to blockchain to get a recommendation on the appropriate 
setting for the Thermostat. The smart contract within blockchain will provide you with the 
changes needed and execute the change on your behalf. Click on the **Get Recommendation** button.

![recommendation button](images/dashboard-recommendation-button.png)

Block chain uses the "Outside Temperature" values in addition to your latest Iot temperature to make a recommendation for you Thermostat.

![recommendation result](images/dashboard-recommendation-result.png)

As you can see the "Thermostat" changed from **36 Degrees to 20 Degrees**.

This concludes the Blockchain Lab. We hope you had fun.






