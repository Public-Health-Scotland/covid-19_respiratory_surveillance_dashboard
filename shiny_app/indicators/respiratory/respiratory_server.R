# Respiratory server ----

metadataButtonServer(id="respiratory",
                     panel="Respiratory infection activity",
                     parent = session)

jumpToTabButtonServer(id="respiratory_from_summary",
                      location="respiratory",
                      parent = session)

respiratoryServer("flu")
respiratoryServer("nonflu")
