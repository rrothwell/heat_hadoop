OpenStack Heat Template In YAML Format
======

Deploy an Hadoop cluster on OpenStack with a user defined slave count.
------

This Heat template, devised for the Havana and Icehouse versions of OpenStack,
is becoming obsolete for 3 reasons:

1. Hadoop is changing
2. The next version of OpenStack, Juno, will support Hadoop directly via Sahara
3. The new template system will be based on HOT

However it might still be useful as a demonstration of a number of tricks
to get complex deployments working on OpenStack.

To use this template login to the OpenStack Dashboard (Horizon).
Navigate to the Heat panel via the side menu bar.
Select an input option to load in the text of the template.
Fill in the form generated by the template.
Run the Heat orchestration engine to build the cluster.

The Heat engine will load the bash scripts from this GitHub repository
and execute them as VM user data.

Wait a while.
Login to the cluster master and verify that HDFS, etc.. is working.