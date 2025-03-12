variable "environment" {
    type = string
    default = "staging"
    description = "for all different environment"
    nullable = false
}
variable "rds_sg_name" {
    type = string
    default = "db_insta_sg"
    description = "rds db instance sg for all enviroment"
}