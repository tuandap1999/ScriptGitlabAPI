# Access Level
- No access (0)
- Guest (10)
- Reporter (20)
- Developer (30)
- Maintainer (40)
- Owner (50) 

#Create AccessToken in Gitlab
- Log in to GitLab.
- Navigate to the project you would like to create an access token for.
- In the Settings menu choose Access Tokens.
- Choose a name and optional expiry date for the token.
- Choose the desired scopes.
- Click the Create project access token button.
- Save the project access token somewhere safe. Once you leave or refresh the page, you won’t be able to access it again.
*Note
+ api	Grants complete read/write access to the scoped project API, including the Package Registry.
+ read_api	Grants read access to the scoped project API, including the Package Registry.
+ read_registry	Allows read-access (pull) to container registry images if a project is private and authorization is required.
+ write_registry	Allows write-access (push) to container registry.
+ read_repository	Allows read-only access (pull) to the repository.
+ write_repository	Allows read-write access (pull, push) to the repository.
