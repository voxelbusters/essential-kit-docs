# Target API Level vs Min API Level

### **Target API Level** &#x20;

This value tells that the app is "tested & compatible till this level". If this is 35, it means your app is tested and **compatible till** Android 15 devices"&#x20;

### **Min API Level**&#x20;

This value tells the app needs minimum this minimum android version to run.&#x20;



### Examples

If Min is 21 and Target is 35, it means it runs on all devices from API 21 to API 35&#x20;

If Min is 24 and Target is 33, it means it runs on all devices from API 24 to API 33 (It may or may not run on 34 and 35 as its not tested with Target API SDK Level 35)&#x20;



So, If you actually target higher api levels and lower min api levels - it means the app is covering very broad range!&#x20;

> Ideally, Target API Level should be renamed as "Max Tested API Level" or "Max Compatible API Level" 😉
