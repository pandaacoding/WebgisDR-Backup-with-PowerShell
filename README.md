# WebgisDR-Backup-with-PowerShell

## Overview of the tool
This powershell scripts will be run via TaskScheduler on the VM machine that hosting ArcGIS Portal and Webadapter for Portal. It will do full and increment backup base on what you set on the TaskScheduler. This script will back up the setting on the Azure Blob environment.

## Problem
Backup each component of ArcGIS portal can be tedious, and slow. Sometimes We just forget about it and never back up the portal setting.

## Solution
Set schedule task to run monthly full back up on Azure Blob. And set Daily run for Increment Back up on Azure Blob.

## Tools Dependencies
1) PowerShell
2) TaskScheduler
3) Azure portal account
4) Azure Blob Container

## Example Product

This is the picture of the product.
![FhMhJGERL8](https://github.com/pandaacoding/WebgisDR-Backup-with-PowerShell/assets/80724379/d35a87cc-9bfa-4ee9-9a94-5bbfa0f22ba7)



