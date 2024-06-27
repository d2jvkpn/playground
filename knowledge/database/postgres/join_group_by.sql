SELECT t1.org_id, t2.name org_name, array_agg(t1.account_id) account_ids
FROM user_org_members t1
INNER JOIN user_orgs t2 ON t1.org_id = t2.id
WHERE t2.status = true
GROUP BY t1.org_id, t2.name
ORDER BY t2.name, t1.org_id;
