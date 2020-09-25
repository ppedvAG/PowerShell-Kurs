configuration WebServerconfiguration
{
    node $AllNodes.NodeName
    {
        LocalConfigurationManager
        {
            ConfigurationMode = "ApplyAndAutoCorrect" #Bei Abweichung Konfig wieder herstellen
            ConfigurationModeFrequencyMins = 15 #Default 15 minuten, kleiner geht nicht, Wert in welchen Abständen geprüft wird
        }

        foreach($Feature in $Node.WindowsFeature)
        {
            WindowsFeature $Feature.Name
            {
                Ensure = $Feature.Ensure
                Name   = $Feature.Name
            }
        }
      
    }
}

# ConfigurationName -configurationData <Pfad zur Datei "ConfigurationData.psd1">
