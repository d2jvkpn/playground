# Domain Suffixes
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
```


#### ch01. 
| Suffix / Name                                           | Official status                                             | Typical use                                    | Recommendation                        | Notes                                                                                                                                         |
| ------------------------------------------------------- | ----------------------------------------------------------- | ---------------------------------------------- | ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `home.arpa`                                             | Reserved special-use domain                                 | Long-term private/home network naming          | **Highly recommended**                | Standardized for residential/private networks. Good for local DNS. ([IANA][1])                                                                |
| `.test`                                                 | Reserved special-use domain                                 | Development, testing, CI, local integration    | **Recommended**                       | Intended for testing. Safe choice for local/dev environments. ([IANA][1])                                                                     |
| `.example`                                              | Reserved special-use domain                                 | Documentation, examples, tutorials             | Recommended for examples only         | Best for sample configs and docs, not the best choice for real deployments. ([IANA][1])                                                       |
| `.local`                                                | Reserved special-use domain                                 | mDNS / Bonjour / Zeroconf                      | Use with caution                      | Valid, but meant for multicast DNS. Avoid using it as a normal unicast DNS suffix if mDNS is present. ([IANA][1])                             |
| `localhost`                                             | Reserved special-use name                                   | Loopback / local machine only                  | Recommended only for same-host use    | Refers to the local host, not other machines on the LAN. ([IANA][1])                                                                          |
| `.invalid`                                              | Reserved special-use domain                                 | Placeholders, negative tests, invalid examples | Niche use only                        | Useful when you want a name that should never resolve. ([IANA][1])                                                                            |
| `.svc`                                                  | Not a reserved suffix                                       | Internal label in Kubernetes DNS names         | **Do not use as a standalone suffix** | Common in names like `service.namespace.svc.cluster.local`; `svc` is a label in Kubernetes DNS, not a standard private TLD. ([Kubernetes][2]) |
| `.internal`                                             | Not currently listed as a finalized IANA special-use domain | Proposed private/internal-use suffix           | Not recommended yet as a standard     | IANA announced a provisional determination in 2024, but it is not shown in the current special-use list I checked. ([IANA][3])                |
| `.lan`                                                  | Not reserved                                                | Informal private LAN naming                    | Not recommended                       | Common in practice, but not standardized or reserved. ([IANA][1])                                                                             |
| `.home`                                                 | Not recommended                                             | Legacy home-network naming                     | Do not use                            | `home.arpa` was standardized to replace older non-standard `.home` usage. ([RFC Editor][4])                                                   |
| `.dev`                                                  | Public delegated TLD                                        | Public developer sites                         | Do not use for local/private DNS      | Real public TLD, so it can conflict with public DNS behavior and browser expectations.                                                        |
| Real public TLDs (`.com`, `.net`, `.org`, `.io`, `.ai`) | Public delegated TLDs                                       | Internet-facing domains                        | Do not use as private-only suffixes   | Better to use a subdomain you control, such as `internal.example.com`.                                                                        |

[1]: https://www.iana.org/assignments/special-use-domain-names?utm_source=chatgpt.com "Special-Use Domain Names"
[2]: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/?utm_source=chatgpt.com "DNS for Services and Pods"
[3]: https://www.iana.org/news/2024/proposed-private-use-tld?utm_source=chatgpt.com "Proposed Top-Level Domain String for Private Use"
[4]: https://www.rfc-editor.org/rfc/rfc8375.html?utm_source=chatgpt.com "RFC 8375: Special-Use Domain 'home.arpa.'"
