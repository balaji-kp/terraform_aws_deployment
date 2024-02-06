output webSG{
 value = aws_security_group.webSg.id
}
output vpc-id{
 value = aws_vpc.myvpc.id
}
output web-tier-sub1{
 value = aws_subnet.web-tier-sub1.id
}
output web-tier-sub2{
 value = aws_subnet.web-tier-sub2.id
}
output app-tier-sub1{
 value = aws_subnet.app-tier-sub1.id
}
output app-tier-sub2{
 value = aws_subnet.app-tier-sub2.id
}
output db-tier-sub1{
 value = aws_subnet.db-tier-sub1.id
}
