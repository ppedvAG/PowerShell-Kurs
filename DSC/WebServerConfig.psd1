@{
    AllNodes = @(
        @{
            NodeName = "Member1"
            WindowsFeature = @(
            @{
                Name = "Web-Server"
                Ensure = "Present"
            }
            )
            }
    )
}