output "noname_server_id" {
  description = "aws_instance id for noname remote engine, useful for configuring traffic mirroring"
  value       = aws_instance.noname_server.id
}
