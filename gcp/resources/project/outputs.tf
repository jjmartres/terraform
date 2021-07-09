output "project" {
  description = "Result is a map with the id, the name and the folder of the created project"
  value       =  map("name", google_project.project.name,
                      "id", google_project.project.project_id,
                      "folder", google_project.project.folder_id )
}