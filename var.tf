variable "ami_webserver" {
    type = string
    default = "ami-0ced6a024bb18ff2e"
  
}
variable "webserver_type" {
    type = string
    default = "t3.micro"
  
}
variable "webserver_termination" {
    type = bool
    default = true
  
}
#variable "webserver_copy" {
    #type = number   
    #default = 2
  
}