
import boto3
region = 'ap-south-1'
instances = ['i-0b7b3b92da3bcc4e1']    #Give instance id to perform action.
# instances = ['i-0b7b3b9*****','i-0b7b3b******',....]   #this for more than one instance.
ec2 = boto3.client('ec2',region_name=region)

def lambda_handler(event,context):
    ec2.start_instances(InstanceIds=instances)
    print('Started your instances: ' + str(instances))
    
    
    
    
