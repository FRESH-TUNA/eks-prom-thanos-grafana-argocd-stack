resource "aws_vpc_endpoint" "s3-thanos" {
  vpc_id    = aws_vpc.monitoring-practice.id
  service_name = "com.amazonaws.ap-northeast-2.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3-thanos-private-a" {
  route_table_id  = aws_route_table.private-a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-thanos.id
}

resource "aws_vpc_endpoint_route_table_association" "s3-thanos-private-b" {
  route_table_id  = aws_route_table.private-b.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-thanos.id
}
