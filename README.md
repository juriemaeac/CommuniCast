# CommuniCast: Location-based incident reporting through community broadcast platform

CommuniCast offers a comprehensive solution to address the challenges of incident reporting. This app provides a user-friendly interface that allows individuals to report incidents with just a few clicks. Users can capture photos, provide detailed descriptions, and specify the incident's location, ensuring accurate and reliable reporting. By leveraging the capabilities of only phone’s GPS, and the internet, CommuniCast enables real-time incident reporting, granting users crucial information about crime, accidents, and other hazards in their area via proximity alert notification.

This mobile application uses Flutter framework which is an open-source UI software development kit (SDK) developed by Google. It also utilizes Firebase for seamless data storage and real-time synchronization. When users submit an incident report through the app, the data is securely stored in the Firebase database. This ensures that all reported incidents are readily accessible and can be retrieved whenever needed.

Firebase also enables real-time synchronization, meaning that any updates made to incident reports are immediately reflected across all devices using the app. This feature ensures that the incident data is always up-to-date and consistent for all users, regardless of their location or the device they are using.

In addition to data storage and synchronization, Firebase provides robust security features, ensuring that sensitive information, such as user details and incident reports, is protected from unauthorized access. User authentication and authorization mechanisms are implemented to ensure that only authorized users have access to specific features and data within the app.

Moreover, Firebase offers convenient cloud-based services that facilitate easy integration of various functionalities. For instance, when users upload pictures of incidents, Firebase Cloud Storage is utilized to securely store and manage these images, making them readily available for viewing and retrieval.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/a16b189e-7a8b-478b-b00c-b475646576d9)

## Incident Color Code

Incidents are color coded based on its type:
RED - Fire and Smoke Conditions
AMBER - Missing Child or Infant
BLUE - Medical Emergency
GREEN - Security Alert
BLACK - Weather Warning


### Login Page:
It uses Firebase Authentication with email verification to avoid fake accounts.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/75b9f7b8-a2f9-4c59-a522-7fce22f598b9)

### Home Page:
The Home page provides visibility to all incidents, and it includes a "nearby" section that allows users to filter incidents based on their location.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/aa25758e-89c0-4965-88f5-4a55ba2ba6af)

### iMap Page:
The iMap page displays all incidents using map pins, allowing users to identify incident-prone areas.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/c366348b-f8a5-4d6a-a1d8-9e0c06358e42)

### Profile Page:
On the profile page, users can view all the incidents they have reported. They are given the option to either edit or delete the incidents according to their preferences.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/4b9ad786-75c7-46b9-94e3-32305d3a41c8)

### Incident Report Page:
The incident report page allows users to report incidents they have witnessed. It includes essential details about the incident, such as a picture taken at the scene and other relevant information.

![image](https://github.com/juriemaeac/Incident-Reporting-App/assets/59803167/abbf8261-7d45-4696-a1f6-bb35ac04ae4d)

## CommuniCast – empowering communities through location-based incident reporting. Together, we can make a difference. Stay safe out there!
# DEVELOPERS
Jurie Mae Castronuevo; 
Lance Philip Parungao; 
Stephen John Chua
