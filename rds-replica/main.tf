resource "aws_db_subnet_group" "rds" {
  name        = "replica-${var.environment}${var.name}-rds"
  description = "The group of subnets"
  subnet_ids  = ["${var.subnets}"]
}

resource "aws_db_instance" "rds" {
  identifier                = "${var.environment}-${var.project}-${var.name}-replica-${var.number}"
  engine                    = "${var.engine}"
  instance_class            = "${var.size}"
  vpc_security_group_ids    = ["${aws_security_group.sg_rds.id}"]
  replicate_source_db       = "${var.replicate_source_db}"
  final_snapshot_identifier = "${var.project}-${var.environment}${var.name}-rds${var.number}-final-${md5(timestamp())}"
  db_subnet_group_name      = "${aws_db_subnet_group.rds.id}"


  tags = "${merge("${var.tags}",
    map("Name", "${var.environment}.${var.project}.${var.name}.replica.${var.number}",
      "service", "${var.name}",
      "environment", "${var.environment}",
      "stack", "${var.project}"))
  }"


  lifecycle {
    ignore_changes = ["final_snapshot_identifier","replicate_source_db"]
  }
}
