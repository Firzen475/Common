

https://gitlab.fzen.pro/api/v4/projects/[project-id]/registry/repositories/
https://gitlab.fzen.pro/api/v4/projects/[project-id]/registry/repositories/[repo-id]/tags/
```shell

curl -f -k -X DELETE \
        -H "Authorization: Bearer glpat-Kp76e3CQrWq0QPiBJBqpt286MQp1OjEH.01.0w11o2hno" \
        "https://gitlab.fzen.pro/api/v4/projects/3/registry/repositories/3/tags//07ce40c2fc1cc10f86845fa19a9f1884d5324fba53331d7083040ff9ad244655"

curl -f -k -X GET \
        -H "Authorization: Bearer glpat-Kp76e3CQrWq0QPiBJBqpt286MQp1OjEH.01.0w11o2hno" \
        "https://gitlab-registry.gitlab.svc:5000/github/ansible-image/"



description="Automated release for tag $CI_COMMIT_TAG \
[Последний образ](https://gitlab.fzen.pro/github/terraform-image/-/releases/permalink/latest/downloads/github-terraform-image) \
[Последний релиз](https://gitlab.fzen.pro/github/terraform-image/-/releases/permalink/latest)"

RELEASE_JSON=$(jq -n \
    --arg name "Release 0.4.3" \
    --arg tag_name "0.4.3" \
    --arg desc_line1 "Automated release for tag $CI_COMMIT_TAG  " \
    --arg desc_line2 "[Последний образ](https://gitlab.fzen.pro/github/terraform-image/-/releases/permalink/latest/downloads/github-terraform-image)  " \
    --arg desc_line3 "[Последний релиз](https://gitlab.fzen.pro/github/terraform-image/-/releases/permalink/latest)  " \
    '{name: $name, tag_name: $tag_name, description: "\($desc_line1)\n\($desc_line2)\n\($desc_line3)", assets: {links: []}}'
)

RELEASE_JSON=$(echo "$RELEASE_JSON" | jq \
  --arg name "gitlab-registry.gitlab.svc:5000/github/terraform-image/dev-ansible:0.4.3" \
  --arg url "https://gitlab.fzen.pro/github/terraform-image/container_registry" \
  --arg link_type "image" \
  --arg direct_asset_path "/github-terraform-image" \
  '.assets.links += [{"name": $name, "url": $url, "link_type": $link_type, "direct_asset_path": $direct_asset_path}]'
)


echo "$RELEASE_JSON"

curl -k -f -X POST \
  -H "Authorization: Bearer glpat-LPdRDYK4e4JXxIQPdhEPE286MQp1Om8H.01.0w0gsf3mi" \
  -H "Content-Type: application/json" \
  -d "${RELEASE_JSON}" \
  "https://gitlab.fzen.pro/api/v4/projects/4/releases"







```