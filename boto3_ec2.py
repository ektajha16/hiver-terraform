import boto3
access_key=""
secret_key=""

ec2=boto3.client('ec2', region_name='us-east-1',aws_access_key_id="",aws_secret_access_keys="")
a=ec2.describe_instances()
for i in a['Reservations']:
     for j in i['Instances']:
        if j['InstanceType']=="t2.micro":
           for k in j['Tags']:
               if k['key']=='Name':
                    print(k['Value'],j['InstanceId'])
