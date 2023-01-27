# Respiratory server ----

metadataButtonServer(id="respiratory",
                     panel="Respiratory",
                     parent = session)

jumpToTabButtonServer(id="respiratory_from_summary",
                      location="respiratory",
                      parent = session)

respiratoryServer("flu", parent=session)
respiratoryServer("nonflu", parent=session)
