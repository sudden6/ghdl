GNATdoc.Documentation = {
  "label": "Vhdl.Sem_Assocs",
  "qualifier": "",
  "summary": [
  ],
  "description": [
  ],
  "entities": [
    {
      "entities": [
        {
          "label": "Missing_Type",
          "qualifier": "",
          "line": 40,
          "column": 9,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 40,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "type"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Type",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "is"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Parameter",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C26"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Port",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C45"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Generic",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C59"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 41,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "                         "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Allowed",
                      "href": "docs/vhdl__sem_assocs___spec.html#L41C26"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C9"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Analyze association chain ASSOC_CHAIN with interfaces from\n"
                },
                {
                  "kind": "span",
                  "text": "INTERFACE_CHAIN.\n"
                },
                {
                  "kind": "span",
                  "text": "Return the level of compatibility between the two chains in LEVEL.\n"
                },
                {
                  "kind": "span",
                  "text": "If FINISH is true, then ASSOC_CHAIN may be modifies (individual assoc\n"
                },
                {
                  "kind": "span",
                  "text": "added), and error messages (if any) are displayed.\n"
                },
                {
                  "kind": "span",
                  "text": "MISSING control unassociated interfaces.\n"
                },
                {
                  "kind": "span",
                  "text": "LOC is the association.\n"
                },
                {
                  "kind": "span",
                  "text": "Sem_Actual_Of_Association_Chain must have been called before.\n"
                }
              ]
            }
          ],
          "literals": [
            {
              "label": "Missing_Parameter",
              "line": 40,
              "column": 26,
              "description": [
              ]
            },
            {
              "label": "Missing_Port",
              "line": 40,
              "column": 45,
              "description": [
              ]
            },
            {
              "label": "Missing_Generic",
              "line": 40,
              "column": 59,
              "description": [
              ]
            },
            {
              "label": "Missing_Allowed",
              "line": 41,
              "column": 26,
              "description": [
              ]
            }
          ]
        }
      ],
      "label": "Simple types"
    },
    {
      "entities": [
        {
          "label": "Check_Port_Association_Bounds_Restrictions",
          "qualifier": "",
          "line": 68,
          "column": 14,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 68,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "procedure"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Check_Port_Association_Bounds_Restrictions",
                      "href": "docs/vhdl__sem_assocs___spec.html#L68C14"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 69,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Formal",
                      "href": "docs/vhdl__sem_assocs___spec.html#L69C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Actual",
                      "href": "docs/vhdl__sem_assocs___spec.html#L69C21"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L69C35"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Check restrictions of LRM02 12.2.4\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Formal",
              "line": 69,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Actual",
              "line": 69,
              "column": 21,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Assoc",
              "line": 69,
              "column": 35,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Check_Port_Association_Mode_Restrictions",
          "qualifier": "",
          "line": 61,
          "column": 13,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 61,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "function"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Check_Port_Association_Mode_Restrictions",
                      "href": "docs/vhdl__sem_assocs___spec.html#L61C13"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 62,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Formal",
                      "href": "docs/vhdl__sem_assocs___spec.html#L62C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir_Interface_Signal_Declaration",
                      "href": "docs/vhdl__nodes___spec.html#L7331C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 63,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Actual",
                      "href": "docs/vhdl__sem_assocs___spec.html#L63C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir_Interface_Signal_Declaration",
                      "href": "docs/vhdl__nodes___spec.html#L7331C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 64,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L64C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 65,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "return"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Boolean"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Check for restrictions in LRM93 1.1.1.2\n"
                },
                {
                  "kind": "span",
                  "text": "Return FALSE in case of error.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Formal",
              "line": 62,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir_Interface_Signal_Declaration",
                "docHref": "docs/vhdl__nodes___spec.html#L7331C12"
              },
              "description": [
              ]
            },
            {
              "label": "Actual",
              "line": 63,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir_Interface_Signal_Declaration",
                "docHref": "docs/vhdl__nodes___spec.html#L7331C12"
              },
              "description": [
              ]
            },
            {
              "label": "Assoc",
              "line": 64,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Check_Subprogram_Association_Expression",
          "qualifier": "",
          "line": 52,
          "column": 14,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 52,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "procedure"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Check_Subprogram_Association_Expression",
                      "href": "docs/vhdl__sem_assocs___spec.html#L52C14"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 53,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Formal",
                      "href": "docs/vhdl__sem_assocs___spec.html#L53C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Actual",
                      "href": "docs/vhdl__sem_assocs___spec.html#L53C21"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L53C35"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Loc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L53C48"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Check association for expression ACTUAL to interface FORMAL.\n"
                },
                {
                  "kind": "span",
                  "text": "ASSOC may be null for operator.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Formal",
              "line": 53,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Actual",
              "line": 53,
              "column": 21,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Assoc",
              "line": 53,
              "column": 35,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Loc",
              "line": 53,
              "column": 48,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Check_Subprogram_Associations",
          "qualifier": "",
          "line": 56,
          "column": 14,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 56,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "procedure"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Check_Subprogram_Associations",
                      "href": "docs/vhdl__sem_assocs___spec.html#L56C14"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 57,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Inter_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L57C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L57C26"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Do port Sem_Association_Chain checks for subprograms.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Inter_Chain",
              "line": 57,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Assoc_Chain",
              "line": 57,
              "column": 26,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Extract_Non_Object_Association",
          "qualifier": "",
          "line": 24,
          "column": 13,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 24,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "function"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Extract_Non_Object_Association",
                      "href": "docs/vhdl__sem_assocs___spec.html#L24C13"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 25,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L25C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Inter_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L25C26"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "return"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Rewrite the association chain by changing the kind of assocation\n"
                },
                {
                  "kind": "span",
                  "text": "corresponding to non-object interfaces.  Such an association mustn't be\n"
                },
                {
                  "kind": "span",
                  "text": "handled an like association for object as the actual is not an\n"
                },
                {
                  "kind": "span",
                  "text": "expression.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Assoc_Chain",
              "line": 25,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Inter_Chain",
              "line": 25,
              "column": 26,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Sem_Actual_Of_Association_Chain",
          "qualifier": "",
          "line": 30,
          "column": 13,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 30,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "function"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Sem_Actual_Of_Association_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L30C13"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L30C46"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "return"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Boolean"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Analyze actuals of ASSOC_CHAIN.\n"
                },
                {
                  "kind": "span",
                  "text": "Check all named associations are after positionnal one.\n"
                },
                {
                  "kind": "span",
                  "text": "Return TRUE if no error.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Assoc_Chain",
              "line": 30,
              "column": 46,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Sem_Association_Chain",
          "qualifier": "",
          "line": 42,
          "column": 14,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 42,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "procedure"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Sem_Association_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L42C14"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 43,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Interface_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L43C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 44,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Assoc_Chain",
                      "href": "docs/vhdl__sem_assocs___spec.html#L44C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "in"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "out"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 45,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Finish",
                      "href": "docs/vhdl__sem_assocs___spec.html#L45C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Boolean"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 46,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing",
                      "href": "docs/vhdl__sem_assocs___spec.html#L46C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Type",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 47,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Loc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L47C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 48,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Match",
                      "href": "docs/vhdl__sem_assocs___spec.html#L48C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "out"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Compatibility_Level",
                      "href": "docs/vhdl__sem_expr___spec.html#L216C9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Interface_Chain",
              "line": 43,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Assoc_Chain",
              "line": 44,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Finish",
              "line": 45,
              "column": 7,
              "type": {
                "label": "Boolean"
              },
              "description": [
              ]
            },
            {
              "label": "Missing",
              "line": 46,
              "column": 7,
              "type": {
                "label": "Vhdl.Sem_Assocs.Missing_Type",
                "docHref": "docs/vhdl__sem_assocs___spec.html#L40C9"
              },
              "description": [
              ]
            },
            {
              "label": "Loc",
              "line": 47,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Match",
              "line": 48,
              "column": 7,
              "type": {
                "label": "Vhdl.Sem_Expr.Compatibility_Level",
                "docHref": "docs/vhdl__sem_expr___spec.html#L216C9"
              },
              "description": [
              ]
            }
          ]
        },
        {
          "label": "Sem_Check_Missing_Association",
          "qualifier": "",
          "line": 101,
          "column": 13,
          "src": "srcs/vhdl-sem_assocs.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 101,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "function"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Sem_Check_Missing_Association",
                      "href": "docs/vhdl__sem_assocs___spec.html#L101C13"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 102,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "     "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Inter",
                      "href": "docs/vhdl__sem_assocs___spec.html#L102C7"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing",
                      "href": "docs/vhdl__sem_assocs___spec.html#L102C20"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Missing_Type",
                      "href": "docs/vhdl__sem_assocs___spec.html#L40C9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Finish",
                      "href": "docs/vhdl__sem_assocs___spec.html#L102C44"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Boolean"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Loc",
                      "href": "docs/vhdl__sem_assocs___spec.html#L102C62"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Iir",
                      "href": "docs/vhdl__nodes___spec.html#L7060C12"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 103,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "return"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Boolean"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "LRM93 8.6 Procedure Call Statement\n"
                },
                {
                  "kind": "span",
                  "text": "For each formal parameter of a procedure, a procedure call must\n"
                },
                {
                  "kind": "span",
                  "text": "specify exactly one corresponding actual parameter.\n"
                },
                {
                  "kind": "span",
                  "text": "This actual parameter is specified either explicitly, by an\n"
                },
                {
                  "kind": "span",
                  "text": "association element (other than the actual OPEN) in the association\n"
                },
                {
                  "kind": "span",
                  "text": "list, or in the absence of such an association element, by a default\n"
                },
                {
                  "kind": "span",
                  "text": "expression (see Section 4.3.3.2).\n"
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "LRM93 7.3.3 Function Calls\n"
                },
                {
                  "kind": "span",
                  "text": "For each formal parameter of a function, a function call must\n"
                },
                {
                  "kind": "span",
                  "text": "specify exactly one corresponding actual parameter.\n"
                },
                {
                  "kind": "span",
                  "text": "This actual parameter is specified either explicitly, by an\n"
                },
                {
                  "kind": "span",
                  "text": "association element (other than the actual OPEN) in the association\n"
                },
                {
                  "kind": "span",
                  "text": "list, or in the absence of such an association element, by a default\n"
                },
                {
                  "kind": "span",
                  "text": "expression (see Section 4.3.3.2).\n"
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "LRM93 1.1.1.2 / LRM08 6.5.6.3 Port clauses\n"
                },
                {
                  "kind": "span",
                  "text": "A port of mode IN may be unconnected or unassociated only if its\n"
                },
                {
                  "kind": "span",
                  "text": "declaration includes a default expression.\n"
                },
                {
                  "kind": "span",
                  "text": "A port of any mode other than IN may be unconnected or unassociated\n"
                },
                {
                  "kind": "span",
                  "text": "as long as its type is not an unconstrained array type.\n"
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "LRM08 6.5.6.2 Generic clauses\n"
                },
                {
                  "kind": "span",
                  "text": "It is an error if no such actual [instantiated package] is specified\n"
                },
                {
                  "kind": "span",
                  "text": "for a given formal generic package (either because the formal generic\n"
                },
                {
                  "kind": "span",
                  "text": "is unassociated or because the actual is OPEN).\n"
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "INTER is an interface that is known not to be associated.\n"
                },
                {
                  "kind": "span",
                  "text": "Report an error according to MISSING iff FINISH is true.\n"
                },
                {
                  "kind": "span",
                  "text": "Return True iff not associating INTER is an error.\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Inter",
              "line": 102,
              "column": 7,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            },
            {
              "label": "Missing",
              "line": 102,
              "column": 20,
              "type": {
                "label": "Vhdl.Sem_Assocs.Missing_Type",
                "docHref": "docs/vhdl__sem_assocs___spec.html#L40C9"
              },
              "description": [
              ]
            },
            {
              "label": "Finish",
              "line": 102,
              "column": 44,
              "type": {
                "label": "Boolean"
              },
              "description": [
              ]
            },
            {
              "label": "Loc",
              "line": 102,
              "column": 62,
              "type": {
                "label": "Vhdl.Nodes.Iir",
                "docHref": "docs/vhdl__nodes___spec.html#L7060C12"
              },
              "description": [
              ]
            }
          ]
        }
      ],
      "label": "Subprograms"
    }
  ]
};