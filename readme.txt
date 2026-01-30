# Project Introduction
An OpenTTD script that makes the game more challenging! Developed by `Recursive Island` 
# Objective
## New Tax Law
A unique tax rate will be set for each company based on its market value. Specifically, the ratio of a company's market value to the average market value of all companies will be calculated and multiplied by the benchmark tax rate to determine the company's tax rate for the current quarter. 
Environmentalism
Due to the excessive damage that aircraft cause to the environment, the government will impose a specific proportion of environmental tax on the profits earned by all aircraft at the end of the year. This tax is unrelated to the market value tax mentioned above. 
## 24-hour Dynamic Passenger Flow Distribution
The relevant functions are implemented based on the `Peaks and Thoughts` script. 
The script assigns company teams based on company IDs. Trains from different teams cannot stop at each other's stations. Trains can stop at stations of other companies within their own team (when infrastructure sharing is enabled). 
Urban Development
Urban development control is based on "Renewed Village Growth". 
# Dependent Script Libraries 
To ensure this script runs properly, please make sure to install 
- `SuperLib`: Version 40
- `GSToyLib`: Version 2 
# Known Issues
- It is not recommended to modify the economic mode or calendar mode during gameplay, as it may result in a repeated market value tax. It is suggested to set these options before starting the game. If you do make changes, saving and exiting the game, then reloading the save file might also resolve this issue.
