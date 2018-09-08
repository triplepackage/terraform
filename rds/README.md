# Create RDS Instance

Create root password environment variable 
<pre>
Johns-MBP:rds admin$ export TF_VAR_mysql_password=xxxxx
</pre>

Terraform Plan
<pre>
Johns-MBP:rds admin$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_db_instance.rental-mysql
    address:                    "<computed>"
    allocated_storage:          "10"
    apply_immediately:          "<computed>"
    arn:                        "<computed>"
    auto_minor_version_upgrade: "true"
    availability_zone:          "<computed>"
    backup_retention_period:    "<computed>"
    backup_window:              "<computed>"
    character_set_name:         "<computed>"
    copy_tags_to_snapshot:      "false"
    db_subnet_group_name:       "<computed>"
    endpoint:                   "<computed>"
    engine:                     "mysql"
    engine_version:             "5.7"
    hosted_zone_id:             "<computed>"
    identifier:                 "<computed>"
    identifier_prefix:          "<computed>"
    instance_class:             "db.t2.micro"
    kms_key_id:                 "<computed>"
    license_model:              "<computed>"
    maintenance_window:         "<computed>"
    monitoring_interval:        "0"
    monitoring_role_arn:        "<computed>"
    multi_az:                   "<computed>"
    name:                       "mydb"
    option_group_name:          "<computed>"
    parameter_group_name:       "default.mysql5.7"
    password:                   "<sensitive>"
    port:                       "3306"
    publicly_accessible:        "true"
    replicas.#:                 "<computed>"
    resource_id:                "<computed>"
    skip_final_snapshot:        "true"
    status:                     "<computed>"
    storage_type:               "gp2"
    timezone:                   "<computed>"
    username:                   "root"
    vpc_security_group_ids.#:   "<computed>"

+ aws_security_group.rental-mysql
    description:                           "RDS MySql servers (terraform-managed)"
    egress.#:                              "1"
    egress.482069346.cidr_blocks.#:        "1"
    egress.482069346.cidr_blocks.0:        "0.0.0.0/0"
    egress.482069346.from_port:            "0"
    egress.482069346.ipv6_cidr_blocks.#:   "0"
    egress.482069346.prefix_list_ids.#:    "0"
    egress.482069346.protocol:             "-1"
    egress.482069346.security_groups.#:    "0"
    egress.482069346.self:                 "false"
    egress.482069346.to_port:              "0"
    ingress.#:                             "1"
    ingress.1163740523.cidr_blocks.#:      "1"
    ingress.1163740523.cidr_blocks.0:      "0.0.0.0/0"
    ingress.1163740523.from_port:          "3306"
    ingress.1163740523.ipv6_cidr_blocks.#: "0"
    ingress.1163740523.protocol:           "tcp"
    ingress.1163740523.security_groups.#:  "0"
    ingress.1163740523.self:               "false"
    ingress.1163740523.to_port:            "3306"
    name:                                  "rental-mysql"
    owner_id:                              "<computed>"
    vpc_id:                                "vpc-c75340a3"


Plan: 2 to add, 0 to change, 0 to destroy.

</pre>

Terraform Apply

<pre>
Johns-MBP:rds admin$ terraform apply
aws_security_group.rental-mysql: Creating...
  description:                           "" => "RDS MySql servers (terraform-managed)"
  egress.#:                              "" => "1"
  egress.482069346.cidr_blocks.#:        "" => "1"
  egress.482069346.cidr_blocks.0:        "" => "0.0.0.0/0"
  egress.482069346.from_port:            "" => "0"
  egress.482069346.ipv6_cidr_blocks.#:   "" => "0"
  egress.482069346.prefix_list_ids.#:    "" => "0"
  egress.482069346.protocol:             "" => "-1"
  egress.482069346.security_groups.#:    "" => "0"
  egress.482069346.self:                 "" => "false"
  egress.482069346.to_port:              "" => "0"
  ingress.#:                             "" => "1"
  ingress.1163740523.cidr_blocks.#:      "" => "1"
  ingress.1163740523.cidr_blocks.0:      "" => "0.0.0.0/0"
  ingress.1163740523.from_port:          "" => "3306"
  ingress.1163740523.ipv6_cidr_blocks.#: "" => "0"
  ingress.1163740523.protocol:           "" => "tcp"
  ingress.1163740523.security_groups.#:  "" => "0"
  ingress.1163740523.self:               "" => "false"
  ingress.1163740523.to_port:            "" => "3306"
  name:                                  "" => "rental-mysql"
  owner_id:                              "" => "<computed>"
  vpc_id:                                "" => "vpc-c75340a3"
aws_security_group.rental-mysql: Creation complete (ID: sg-077dd742cc77d9edf)
aws_db_instance.rental-mysql: Creating...
  address:                          "" => "<computed>"
  allocated_storage:                "" => "10"
  apply_immediately:                "" => "<computed>"
  arn:                              "" => "<computed>"
  auto_minor_version_upgrade:       "" => "true"
  availability_zone:                "" => "<computed>"
  backup_retention_period:          "" => "<computed>"
  backup_window:                    "" => "<computed>"
  character_set_name:               "" => "<computed>"
  copy_tags_to_snapshot:            "" => "false"
  db_subnet_group_name:             "" => "<computed>"
  endpoint:                         "" => "<computed>"
  engine:                           "" => "mysql"
  engine_version:                   "" => "5.7"
  hosted_zone_id:                   "" => "<computed>"
  identifier:                       "" => "<computed>"
  identifier_prefix:                "" => "<computed>"
  instance_class:                   "" => "db.t2.micro"
  kms_key_id:                       "" => "<computed>"
  license_model:                    "" => "<computed>"
  maintenance_window:               "" => "<computed>"
  monitoring_interval:              "" => "0"
  monitoring_role_arn:              "" => "<computed>"
  multi_az:                         "" => "<computed>"
  name:                             "" => "mydb"
  option_group_name:                "" => "<computed>"
  parameter_group_name:             "" => "default.mysql5.7"
  password:                         "<sensitive>" => "<sensitive>"
  port:                             "" => "3306"
  publicly_accessible:              "" => "true"
  replicas.#:                       "" => "<computed>"
  resource_id:                      "" => "<computed>"
  skip_final_snapshot:              "" => "true"
  status:                           "" => "<computed>"
  storage_type:                     "" => "gp2"
  timezone:                         "" => "<computed>"
  username:                         "" => "root"
  vpc_security_group_ids.#:         "" => "1"
  vpc_security_group_ids.144172464: "" => "sg-077dd742cc77d9edf"
aws_db_instance.rental-mysql: Still creating... (10s elapsed)
aws_db_instance.rental-mysql: Still creating... (20s elapsed)
aws_db_instance.rental-mysql: Still creating... (30s elapsed)
aws_db_instance.rental-mysql: Still creating... (40s elapsed)
aws_db_instance.rental-mysql: Still creating... (50s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m0s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m10s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m20s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m30s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m40s elapsed)
aws_db_instance.rental-mysql: Still creating... (1m51s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m1s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m11s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m21s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m31s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m41s elapsed)
aws_db_instance.rental-mysql: Still creating... (2m51s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m1s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m11s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m21s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m31s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m41s elapsed)
aws_db_instance.rental-mysql: Still creating... (3m51s elapsed)
aws_db_instance.rental-mysql: Still creating... (4m1s elapsed)
aws_db_instance.rental-mysql: Creation complete (ID: terraform-0000b5ceb46183d84557aa5c0a)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: 

</pre>

Verify Successful creation in AWS Console
![Alt text](images/image004.jpg?raw=true "AWS")
![Alt text](images/image003.jpg?raw=true "AWS")
![Alt text](images/image002.jpg?raw=true "AWS")
![Alt text](images/image001.jpg?raw=true "AWS")

