{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 9,
      "minor": 1,
      "revision": 3,
      "architecture": "arm64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      40,
      80,
      1190,
      210
    ],
    "openinpresentation": 1,
    "devicewidth": 1190,
    "bgcolor": [
      0.055,
      0.065,
      0.085,
      1
    ],
    "editing_bgcolor": [
      0.14,
      0.16,
      0.19,
      1
    ],
    "default_fontname": "Arial",
    "default_fontsize": 11,
    "boxes": [
      {
        "box": {
          "id": "background",
          "maxclass": "panel",
          "patching_rect": [
            0,
            0,
            1190,
            169
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            1190,
            169
          ],
          "bgcolor": [
            0.055,
            0.065,
            0.085,
            1
          ],
          "border": 0,
          "background": 1,
          "varname": "background"
        }
      },
      {
        "box": {
          "id": "brand",
          "maxclass": "comment",
          "patching_rect": [
            10,
            4,
            150,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            4,
            150,
            16
          ],
          "text": "QUADRA / GRAIN",
          "fontsize": 12,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "brand"
        }
      },
      {
        "box": {
          "id": "sub",
          "maxclass": "comment",
          "patching_rect": [
            10,
            22,
            155,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            22,
            155,
            16
          ],
          "text": "4-SOURCE GRANULAR",
          "fontsize": 9,
          "textcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "varname": "sub"
        }
      },
      {
        "box": {
          "id": "engine",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            250,
            180,
            22
          ],
          "text": "gen~ quadra_resample_engine @nocache 1",
          "numinlets": 2,
          "numoutlets": 4,
          "varname": "engine"
        }
      },
      {
        "box": {
          "id": "feedback_temp",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            275,
            180,
            22
          ],
          "text": "buffer~ #0-regrain 4000 2 @embed 0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "feedback_temp"
        }
      },
      {
        "box": {
          "id": "regrain_engine",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            300,
            180,
            22
          ],
          "text": "gen~ quadra_regrain_v3 @nocache 1",
          "numinlets": 1,
          "numoutlets": 3,
          "varname": "regrain_engine"
        }
      },
      {
        "box": {
          "id": "regrain_send_l",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            325,
            180,
            22
          ],
          "text": "send~ #0-rgl",
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "regrain_send_l"
        }
      },
      {
        "box": {
          "id": "regrain_send_r",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            350,
            180,
            22
          ],
          "text": "send~ #0-rgr",
          "numinlets": 1,
          "numoutlets": 0,
          "varname": "regrain_send_r"
        }
      },
      {
        "box": {
          "id": "regrain_return_l",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            375,
            180,
            22
          ],
          "text": "receive~ #0-rgl",
          "numinlets": 0,
          "numoutlets": 1,
          "varname": "regrain_return_l"
        }
      },
      {
        "box": {
          "id": "regrain_return_r",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            400,
            180,
            22
          ],
          "text": "receive~ #0-rgr",
          "numinlets": 0,
          "numoutlets": 1,
          "varname": "regrain_return_r"
        }
      },
      {
        "box": {
          "id": "feedback_sum_l",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            425,
            180,
            22
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "varname": "feedback_sum_l"
        }
      },
      {
        "box": {
          "id": "feedback_sum_r",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            450,
            180,
            22
          ],
          "text": "+~",
          "numinlets": 2,
          "numoutlets": 1,
          "varname": "feedback_sum_r"
        }
      },
      {
        "box": {
          "id": "feedback_clip_l",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            475,
            180,
            22
          ],
          "text": "clip~ -1. 1.",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "feedback_clip_l"
        }
      },
      {
        "box": {
          "id": "feedback_clip_r",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            500,
            180,
            22
          ],
          "text": "clip~ -1. 1.",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "feedback_clip_r"
        }
      },
      {
        "box": {
          "id": "feedback_record",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            525,
            180,
            22
          ],
          "text": "record~ #0-regrain 2 @loop 1",
          "numinlets": 4,
          "numoutlets": 1,
          "varname": "feedback_record"
        }
      },
      {
        "box": {
          "id": "feedback_record_on",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            550,
            180,
            22
          ],
          "text": "loadmess 1",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "feedback_record_on"
        }
      },
      {
        "box": {
          "id": "freeze_engine",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            575,
            180,
            22
          ],
          "text": "gen~ quadra_audio_freeze @nocache 1",
          "numinlets": 2,
          "numoutlets": 2,
          "varname": "freeze_engine"
        }
      },
      {
        "box": {
          "id": "controller",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            600,
            180,
            22
          ],
          "text": "js quadra_resample_ui.js #0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "controller"
        }
      },
      {
        "box": {
          "id": "audioin",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            625,
            180,
            22
          ],
          "text": "plugin~",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "audioin"
        }
      },
      {
        "box": {
          "id": "audioout",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            650,
            180,
            22
          ],
          "text": "plugout~",
          "numinlets": 2,
          "numoutlets": 0,
          "varname": "audioout"
        }
      },
      {
        "box": {
          "id": "meters",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            675,
            180,
            22
          ],
          "text": "snapshot~ 100",
          "numinlets": 2,
          "numoutlets": 1,
          "varname": "meters"
        }
      },
      {
        "box": {
          "id": "actmsg",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            700,
            180,
            22
          ],
          "text": "prepend active",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "actmsg"
        }
      },
      {
        "box": {
          "id": "remeter",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            725,
            180,
            22
          ],
          "text": "snapshot~ 100",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "remeter"
        }
      },
      {
        "box": {
          "id": "remsg",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            750,
            180,
            22
          ],
          "text": "prepend revoices",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "remsg"
        }
      },
      {
        "box": {
          "id": "scanmeter",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            775,
            180,
            22
          ],
          "text": "snapshot~ 100",
          "numinlets": 2,
          "numoutlets": 1,
          "varname": "scanmeter"
        }
      },
      {
        "box": {
          "id": "scmsg",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            800,
            180,
            22
          ],
          "text": "prepend scanpos",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "scmsg"
        }
      },
      {
        "box": {
          "id": "feedback_name_route",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            825,
            180,
            22
          ],
          "text": "route fbtemp",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "feedback_name_route"
        }
      },
      {
        "box": {
          "id": "feedback_name_prepend",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            850,
            180,
            22
          ],
          "text": "prepend fbtemp",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "feedback_name_prepend"
        }
      },
      {
        "box": {
          "id": "active",
          "maxclass": "comment",
          "patching_rect": [
            10,
            144,
            150,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            144,
            150,
            16
          ],
          "text": "GRAINS 0 + 0",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "active"
        }
      },
      {
        "box": {
          "id": "pad",
          "maxclass": "pictslider",
          "patching_rect": [
            170,
            24,
            122,
            122
          ],
          "presentation": 1,
          "presentation_rect": [
            170,
            24,
            122,
            122
          ],
          "leftvalue": 0,
          "rightvalue": 1000,
          "topvalue": 1000,
          "bottomvalue": 0,
          "parameter_enable": 0,
          "horizontaltracking": 1.0,
          "verticaltracking": 1.0,
          "varname": "pad"
        }
      },
      {
        "box": {
          "id": "aCorner",
          "maxclass": "comment",
          "patching_rect": [
            172,
            6,
            20,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            172,
            6,
            20,
            16
          ],
          "text": "A",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "aCorner"
        }
      },
      {
        "box": {
          "id": "bCorner",
          "maxclass": "comment",
          "patching_rect": [
            279,
            6,
            20,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            279,
            6,
            20,
            16
          ],
          "text": "B",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "bCorner"
        }
      },
      {
        "box": {
          "id": "cCorner",
          "maxclass": "comment",
          "patching_rect": [
            172,
            148,
            20,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            172,
            148,
            20,
            16
          ],
          "text": "C",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "cCorner"
        }
      },
      {
        "box": {
          "id": "dCorner",
          "maxclass": "comment",
          "patching_rect": [
            279,
            148,
            20,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            279,
            148,
            20,
            16
          ],
          "text": "D",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "dCorner"
        }
      },
      {
        "box": {
          "id": "padx",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            875,
            180,
            22
          ],
          "text": "prepend padx",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "padx"
        }
      },
      {
        "box": {
          "id": "pady",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            900,
            180,
            22
          ],
          "text": "prepend pady",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "pady"
        }
      },
      {
        "box": {
          "id": "posread",
          "maxclass": "comment",
          "patching_rect": [
            305,
            145,
            125,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            305,
            145,
            125,
            16
          ],
          "text": "SCAN 0.250",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "posread"
        }
      },
      {
        "box": {
          "id": "morphx",
          "maxclass": "live.numbox",
          "patching_rect": [
            305,
            43,
            66,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            305,
            43,
            66,
            19
          ],
          "varname": "morphx",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Morph X",
              "parameter_shortname": "Morph X",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.5
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "morphx_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            925,
            180,
            22
          ],
          "text": "prepend morphx",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "morphx_send"
        }
      },
      {
        "box": {
          "id": "morphx_ui",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            950,
            180,
            22
          ],
          "text": "prepend morphx",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "morphx_ui"
        }
      },
      {
        "box": {
          "id": "morphy",
          "maxclass": "live.numbox",
          "patching_rect": [
            305,
            82,
            66,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            305,
            82,
            66,
            19
          ],
          "varname": "morphy",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Morph Y",
              "parameter_shortname": "Morph Y",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.5
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "morphy_send",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            975,
            180,
            22
          ],
          "text": "prepend morphy",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "morphy_send"
        }
      },
      {
        "box": {
          "id": "morphy_ui",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1000,
            180,
            22
          ],
          "text": "prepend morphy",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "morphy_ui"
        }
      },
      {
        "box": {
          "id": "xlab",
          "maxclass": "comment",
          "patching_rect": [
            305,
            26,
            80,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            305,
            26,
            80,
            16
          ],
          "text": "MORPH X",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "xlab"
        }
      },
      {
        "box": {
          "id": "ylab",
          "maxclass": "comment",
          "patching_rect": [
            305,
            65,
            80,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            305,
            65,
            80,
            16
          ],
          "text": "MORPH Y",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "ylab"
        }
      },
      {
        "box": {
          "id": "run",
          "maxclass": "live.toggle",
          "patching_rect": [
            10,
            49,
            20,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            49,
            20,
            20
          ],
          "varname": "run",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Run",
              "parameter_shortname": "Run",
              "parameter_type": 1,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 0
            }
          },
          "activebgcolor": [
            0.19,
            0.23,
            0.27,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "activebgoncolor": [
            0.34,
            0.86,
            0.75,
            1
          ]
        }
      },
      {
        "box": {
          "id": "run_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1025,
            180,
            22
          ],
          "text": "prepend run",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "run_send"
        }
      },
      {
        "box": {
          "id": "runlabel",
          "maxclass": "comment",
          "patching_rect": [
            35,
            50,
            42,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            35,
            50,
            42,
            16
          ],
          "text": "RUN",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "runlabel"
        }
      },
      {
        "box": {
          "id": "freeze",
          "maxclass": "live.toggle",
          "patching_rect": [
            82,
            49,
            20,
            20
          ],
          "presentation": 1,
          "presentation_rect": [
            82,
            49,
            20,
            20
          ],
          "varname": "freeze",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 1,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Freeze",
              "parameter_shortname": "Freeze",
              "parameter_type": 1,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 0
            }
          },
          "activebgcolor": [
            0.19,
            0.23,
            0.27,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "activebgoncolor": [
            0.34,
            0.86,
            0.75,
            1
          ]
        }
      },
      {
        "box": {
          "id": "freeze_send",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            1050,
            180,
            22
          ],
          "text": "prepend freeze",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "freeze_send"
        }
      },
      {
        "box": {
          "id": "frlabel",
          "maxclass": "comment",
          "patching_rect": [
            107,
            50,
            60,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            107,
            50,
            60,
            16
          ],
          "text": "FREEZE",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "frlabel"
        }
      },
      {
        "box": {
          "id": "output",
          "maxclass": "live.dial",
          "patching_rect": [
            14,
            83,
            68,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            14,
            83,
            68,
            48
          ],
          "varname": "output",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Output",
              "parameter_shortname": "Output",
              "parameter_type": 0,
              "parameter_mmin": -60,
              "parameter_mmax": 0,
              "parameter_initial": [
                -15
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4,
              "parameter_modmode": 2,
              "parameter_units": "dB"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "output_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1075,
            180,
            22
          ],
          "text": "prepend output",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "output_send"
        }
      },
      {
        "box": {
          "id": "macro",
          "maxclass": "live.dial",
          "patching_rect": [
            88,
            83,
            70,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            88,
            83,
            70,
            48
          ],
          "varname": "macro",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Macro Randomness",
              "parameter_shortname": "Randomness",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "macro_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1100,
            180,
            22
          ],
          "text": "prepend macro",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "macro_send"
        }
      },
      {
        "box": {
          "id": "page",
          "maxclass": "live.menu",
          "patching_rect": [
            401,
            5,
            191,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            401,
            5,
            191,
            19
          ],
          "varname": "page",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Panel",
              "parameter_shortname": "Panel",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 3,
              "parameter_initial": [
                2
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "GRAINS / MOTION",
                "RANDOM / SPACE",
                "SAMPLES / REGIONS",
                "MODULATION"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "page_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1125,
            180,
            22
          ],
          "text": "prepend page",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "page_send"
        }
      },
      {
        "box": {
          "id": "size",
          "maxclass": "live.dial",
          "patching_rect": [
            405,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            33,
            94,
            48
          ],
          "varname": "size",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Grain Size",
              "parameter_shortname": "Grain Size",
              "parameter_type": 0,
              "parameter_mmin": 5,
              "parameter_mmax": 1000,
              "parameter_initial": [
                120
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 2,
              "parameter_modmode": 2,
              "parameter_units": "ms"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "size_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1150,
            180,
            22
          ],
          "text": "prepend size",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "size_send"
        }
      },
      {
        "box": {
          "id": "density",
          "maxclass": "live.dial",
          "patching_rect": [
            513,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            513,
            33,
            94,
            48
          ],
          "varname": "density",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Density",
              "parameter_shortname": "Density",
              "parameter_type": 0,
              "parameter_mmin": 0.5,
              "parameter_mmax": 150,
              "parameter_initial": [
                24
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 3,
              "parameter_modmode": 2,
              "parameter_units": "Hz"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "density_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1175,
            180,
            22
          ],
          "text": "prepend density",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "density_send"
        }
      },
      {
        "box": {
          "id": "amount",
          "maxclass": "live.dial",
          "patching_rect": [
            621,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            621,
            33,
            94,
            48
          ],
          "varname": "amount",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Grain Amount",
              "parameter_shortname": "Grain Amount",
              "parameter_type": 1,
              "parameter_mmin": 1,
              "parameter_mmax": 64,
              "parameter_initial": [
                32
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 0,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "amount_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1200,
            180,
            22
          ],
          "text": "prepend amount",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "amount_send"
        }
      },
      {
        "box": {
          "id": "pitch",
          "maxclass": "live.dial",
          "patching_rect": [
            729,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            729,
            33,
            94,
            48
          ],
          "varname": "pitch",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Pitch",
              "parameter_shortname": "Pitch",
              "parameter_type": 0,
              "parameter_mmin": -36,
              "parameter_mmax": 36,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 7,
              "parameter_modmode": 2,
              "parameter_units": "st"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "pitch_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1225,
            180,
            22
          ],
          "text": "prepend pitch",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "pitch_send"
        }
      },
      {
        "box": {
          "id": "position",
          "maxclass": "live.dial",
          "patching_rect": [
            837,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            837,
            33,
            94,
            48
          ],
          "varname": "position",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Position",
              "parameter_shortname": "Position",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "position_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1250,
            180,
            22
          ],
          "text": "prepend position",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "position_send"
        }
      },
      {
        "box": {
          "id": "scan",
          "maxclass": "live.dial",
          "patching_rect": [
            945,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            945,
            33,
            94,
            48
          ],
          "varname": "scan",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Scan Speed",
              "parameter_shortname": "Scan Speed",
              "parameter_type": 0,
              "parameter_mmin": -1,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.03
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 2,
              "parameter_units": "cyc/s"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "scan_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1275,
            180,
            22
          ],
          "text": "prepend scan",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "scan_send"
        }
      },
      {
        "box": {
          "id": "rate",
          "maxclass": "live.dial",
          "patching_rect": [
            1053,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            1053,
            33,
            94,
            48
          ],
          "varname": "rate",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Playback Rate",
              "parameter_shortname": "Playback Rate",
              "parameter_type": 0,
              "parameter_mmin": 0.125,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 2,
              "parameter_units": "x"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "rate_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1300,
            180,
            22
          ],
          "text": "prepend rate",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "rate_send"
        }
      },
      {
        "box": {
          "id": "reverse",
          "maxclass": "live.dial",
          "patching_rect": [
            405,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            98,
            94,
            48
          ],
          "varname": "reverse",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Reverse Prob",
              "parameter_shortname": "Reverse Prob",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "reverse_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1325,
            180,
            22
          ],
          "text": "prepend reverse",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "reverse_send"
        }
      },
      {
        "box": {
          "id": "shape",
          "maxclass": "live.dial",
          "patching_rect": [
            513,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            513,
            98,
            94,
            48
          ],
          "varname": "shape",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Envelope Shape",
              "parameter_shortname": "Envelope Shape",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 2,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "shape_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1350,
            180,
            22
          ],
          "text": "prepend shape",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "shape_send"
        }
      },
      {
        "box": {
          "id": "bias",
          "maxclass": "live.dial",
          "patching_rect": [
            621,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            621,
            98,
            94,
            48
          ],
          "varname": "bias",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Attack Bias",
              "parameter_shortname": "Attack Bias",
              "parameter_type": 0,
              "parameter_mmin": 0.05,
              "parameter_mmax": 0.95,
              "parameter_initial": [
                0.5
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "bias_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1375,
            180,
            22
          ],
          "text": "prepend bias",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "bias_send"
        }
      },
      {
        "box": {
          "id": "cutoff",
          "maxclass": "live.dial",
          "patching_rect": [
            729,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            729,
            98,
            94,
            48
          ],
          "varname": "cutoff",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Grain Cutoff",
              "parameter_shortname": "Grain Cutoff",
              "parameter_type": 0,
              "parameter_mmin": 40,
              "parameter_mmax": 18000,
              "parameter_initial": [
                10000
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 3,
              "parameter_modmode": 2,
              "parameter_units": "Hz"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "cutoff_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1400,
            180,
            22
          ],
          "text": "prepend cutoff",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "cutoff_send"
        }
      },
      {
        "box": {
          "id": "resonance",
          "maxclass": "live.dial",
          "patching_rect": [
            837,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            837,
            98,
            94,
            48
          ],
          "varname": "resonance",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Grain Q",
              "parameter_shortname": "Grain Q",
              "parameter_type": 0,
              "parameter_mmin": 0.5,
              "parameter_mmax": 8,
              "parameter_initial": [
                0.707
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "resonance_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1425,
            180,
            22
          ],
          "text": "prepend resonance",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "resonance_send"
        }
      },
      {
        "box": {
          "id": "feedback",
          "maxclass": "live.dial",
          "patching_rect": [
            945,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            945,
            98,
            94,
            48
          ],
          "varname": "feedback",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Feedback",
              "parameter_shortname": "Feedback",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 0.85,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "feedback_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1450,
            180,
            22
          ],
          "text": "prepend feedback",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "feedback_send"
        }
      },
      {
        "box": {
          "id": "fbdelay",
          "maxclass": "live.dial",
          "patching_rect": [
            1053,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            1053,
            98,
            94,
            48
          ],
          "varname": "fbdelay",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Feedback Delay",
              "parameter_shortname": "Feedback Delay",
              "parameter_type": 0,
              "parameter_mmin": 50,
              "parameter_mmax": 2000,
              "parameter_initial": [
                350
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 2,
              "parameter_modmode": 2,
              "parameter_units": "ms"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "fbdelay_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1475,
            180,
            22
          ],
          "text": "prepend fbdelay",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "fbdelay_send"
        }
      },
      {
        "box": {
          "id": "spray",
          "maxclass": "live.dial",
          "patching_rect": [
            405,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            33,
            94,
            48
          ],
          "varname": "spray",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Position Jitter",
              "parameter_shortname": "Position Jitter",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.05
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "spray_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1500,
            180,
            22
          ],
          "text": "prepend spray",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "spray_send"
        }
      },
      {
        "box": {
          "id": "sizej",
          "maxclass": "live.dial",
          "patching_rect": [
            513,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            513,
            33,
            94,
            48
          ],
          "varname": "sizej",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Size Random",
              "parameter_shortname": "Size Random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "sizej_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1525,
            180,
            22
          ],
          "text": "prepend sizej",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "sizej_send"
        }
      },
      {
        "box": {
          "id": "densityj",
          "maxclass": "live.dial",
          "patching_rect": [
            621,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            621,
            33,
            94,
            48
          ],
          "varname": "densityj",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Density Random",
              "parameter_shortname": "Density Random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "densityj_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1550,
            180,
            22
          ],
          "text": "prepend densityj",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "densityj_send"
        }
      },
      {
        "box": {
          "id": "pitchj",
          "maxclass": "live.dial",
          "patching_rect": [
            729,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            729,
            33,
            94,
            48
          ],
          "varname": "pitchj",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Pitch Jitter",
              "parameter_shortname": "Pitch Jitter",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 24,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 7,
              "parameter_modmode": 2,
              "parameter_units": "st"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "pitchj_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1575,
            180,
            22
          ],
          "text": "prepend pitchj",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "pitchj_send"
        }
      },
      {
        "box": {
          "id": "pan",
          "maxclass": "live.dial",
          "patching_rect": [
            837,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            837,
            33,
            94,
            48
          ],
          "varname": "pan",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Pan",
              "parameter_shortname": "Pan",
              "parameter_type": 0,
              "parameter_mmin": -1,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "pan_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1600,
            180,
            22
          ],
          "text": "prepend pan",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "pan_send"
        }
      },
      {
        "box": {
          "id": "spread",
          "maxclass": "live.dial",
          "patching_rect": [
            945,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            945,
            33,
            94,
            48
          ],
          "varname": "spread",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Pan Spread",
              "parameter_shortname": "Pan Spread",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0.25
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "spread_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1625,
            180,
            22
          ],
          "text": "prepend spread",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "spread_send"
        }
      },
      {
        "box": {
          "id": "filterj",
          "maxclass": "live.dial",
          "patching_rect": [
            1053,
            33,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            1053,
            33,
            94,
            48
          ],
          "varname": "filterj",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Filter Random",
              "parameter_shortname": "Filter Random",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 4,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 2,
              "parameter_units": "oct"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "filterj_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1650,
            180,
            22
          ],
          "text": "prepend filterj",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "filterj_send"
        }
      },
      {
        "box": {
          "id": "inputgain",
          "maxclass": "live.dial",
          "patching_rect": [
            405,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            98,
            94,
            48
          ],
          "varname": "inputgain",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Input Capture",
              "parameter_shortname": "Input Capture",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "inputgain_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1675,
            180,
            22
          ],
          "text": "prepend inputgain",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "inputgain_send"
        }
      },
      {
        "box": {
          "id": "fbsize",
          "maxclass": "live.dial",
          "patching_rect": [
            513,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            513,
            98,
            94,
            48
          ],
          "varname": "fbsize",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Regrain Size",
              "parameter_shortname": "Regrain Size",
              "parameter_type": 0,
              "parameter_mmin": 0.25,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 2,
              "parameter_units": "x"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "fbsize_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1700,
            180,
            22
          ],
          "text": "prepend fbsize",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "fbsize_send"
        }
      },
      {
        "box": {
          "id": "fbdensity",
          "maxclass": "live.dial",
          "patching_rect": [
            621,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            621,
            98,
            94,
            48
          ],
          "varname": "fbdensity",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Regrain Density",
              "parameter_shortname": "Regrain Density",
              "parameter_type": 0,
              "parameter_mmin": 0.25,
              "parameter_mmax": 4,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 2,
              "parameter_units": "x"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "fbdensity_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            1725,
            180,
            22
          ],
          "text": "prepend fbdensity",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "fbdensity_send"
        }
      },
      {
        "box": {
          "id": "fbpitch",
          "maxclass": "live.dial",
          "patching_rect": [
            729,
            98,
            94,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            729,
            98,
            94,
            48
          ],
          "varname": "fbpitch",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Regrain Pitch",
              "parameter_shortname": "Regrain Pitch",
              "parameter_type": 0,
              "parameter_mmin": -24,
              "parameter_mmax": 24,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 7,
              "parameter_modmode": 2,
              "parameter_units": "st"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "fbpitch_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            1750,
            180,
            22
          ],
          "text": "prepend fbpitch",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "fbpitch_send"
        }
      },
      {
        "box": {
          "id": "filtermode",
          "maxclass": "live.menu",
          "patching_rect": [
            947,
            5,
            105,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            947,
            5,
            105,
            19
          ],
          "varname": "filtermode",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Filter Mode",
              "parameter_shortname": "Filter Mode",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 3,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "Bypass",
                "Lowpass",
                "Bandpass",
                "Highpass"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "filtermode_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            1775,
            180,
            22
          ],
          "text": "prepend filtermode",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "filtermode_send"
        }
      },
      {
        "box": {
          "id": "filterlabel",
          "maxclass": "comment",
          "patching_rect": [
            1060,
            7,
            126,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            1060,
            7,
            126,
            16
          ],
          "text": "PER-GRAIN FILTER",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "filterlabel"
        }
      },
      {
        "box": {
          "id": "lfo1rate",
          "maxclass": "live.dial",
          "patching_rect": [
            440,
            29,
            100,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            440,
            29,
            100,
            48
          ],
          "varname": "lfo1rate",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 1 Rate",
              "parameter_shortname": "LFO 1 Rate",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 20,
              "parameter_initial": [
                0.13
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 3,
              "parameter_modmode": 2,
              "parameter_units": "Hz"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo1rate_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            1800,
            180,
            22
          ],
          "text": "prepend lfo1rate",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo1rate_send"
        }
      },
      {
        "box": {
          "id": "lfo1depth",
          "maxclass": "live.dial",
          "patching_rect": [
            550,
            29,
            100,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            550,
            29,
            100,
            48
          ],
          "varname": "lfo1depth",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 1 Depth",
              "parameter_shortname": "LFO 1 Depth",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo1depth_send",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            1825,
            180,
            22
          ],
          "text": "prepend lfo1depth",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo1depth_send"
        }
      },
      {
        "box": {
          "id": "lfo1dest",
          "maxclass": "live.menu",
          "patching_rect": [
            440,
            92,
            163,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            440,
            92,
            163,
            19
          ],
          "varname": "lfo1dest",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 1 Target",
              "parameter_shortname": "LFO 1 Target",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 24,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "Off",
                "Morph X",
                "Morph Y",
                "Grain Size",
                "Density",
                "Grain Amount",
                "Pitch",
                "Position",
                "Scan Speed",
                "Position Jitter",
                "Size Random",
                "Density Random",
                "Pitch Jitter",
                "Playback Rate",
                "Reverse Prob",
                "Envelope Shape",
                "Attack Bias",
                "Pan",
                "Pan Spread",
                "Macro Randomness",
                "Feedback",
                "Feedback Delay",
                "Grain Cutoff",
                "Grain Q",
                "Filter Random"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo1dest_send",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            1850,
            180,
            22
          ],
          "text": "prepend lfo1dest",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo1dest_send"
        }
      },
      {
        "box": {
          "id": "lfo1shape",
          "maxclass": "live.menu",
          "patching_rect": [
            440,
            119,
            163,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            440,
            119,
            163,
            19
          ],
          "varname": "lfo1shape",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 1 Shape",
              "parameter_shortname": "LFO 1 Shape",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 3,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "Sine",
                "Triangle",
                "Ramp",
                "S&H"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo1shape_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            1875,
            180,
            22
          ],
          "text": "prepend lfo1shape",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo1shape_send"
        }
      },
      {
        "box": {
          "id": "lfo2rate",
          "maxclass": "live.dial",
          "patching_rect": [
            780,
            29,
            100,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            780,
            29,
            100,
            48
          ],
          "varname": "lfo2rate",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 2 Rate",
              "parameter_shortname": "LFO 2 Rate",
              "parameter_type": 0,
              "parameter_mmin": 0.01,
              "parameter_mmax": 20,
              "parameter_initial": [
                0.07
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 3,
              "parameter_modmode": 2,
              "parameter_units": "Hz"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo2rate_send",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            1900,
            180,
            22
          ],
          "text": "prepend lfo2rate",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo2rate_send"
        }
      },
      {
        "box": {
          "id": "lfo2depth",
          "maxclass": "live.dial",
          "patching_rect": [
            890,
            29,
            100,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            890,
            29,
            100,
            48
          ],
          "varname": "lfo2depth",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 2 Depth",
              "parameter_shortname": "LFO 2 Depth",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo2depth_send",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            1925,
            180,
            22
          ],
          "text": "prepend lfo2depth",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo2depth_send"
        }
      },
      {
        "box": {
          "id": "lfo2dest",
          "maxclass": "live.menu",
          "patching_rect": [
            780,
            92,
            163,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            780,
            92,
            163,
            19
          ],
          "varname": "lfo2dest",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 2 Target",
              "parameter_shortname": "LFO 2 Target",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 24,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "Off",
                "Morph X",
                "Morph Y",
                "Grain Size",
                "Density",
                "Grain Amount",
                "Pitch",
                "Position",
                "Scan Speed",
                "Position Jitter",
                "Size Random",
                "Density Random",
                "Pitch Jitter",
                "Playback Rate",
                "Reverse Prob",
                "Envelope Shape",
                "Attack Bias",
                "Pan",
                "Pan Spread",
                "Macro Randomness",
                "Feedback",
                "Feedback Delay",
                "Grain Cutoff",
                "Grain Q",
                "Filter Random"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo2dest_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            1950,
            180,
            22
          ],
          "text": "prepend lfo2dest",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo2dest_send"
        }
      },
      {
        "box": {
          "id": "lfo2shape",
          "maxclass": "live.menu",
          "patching_rect": [
            780,
            119,
            163,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            780,
            119,
            163,
            19
          ],
          "varname": "lfo2shape",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 3,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "LFO 2 Shape",
              "parameter_shortname": "LFO 2 Shape",
              "parameter_type": 2,
              "parameter_mmin": 0,
              "parameter_mmax": 3,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 9,
              "parameter_modmode": 0,
              "parameter_enum": [
                "Sine",
                "Triangle",
                "Ramp",
                "S&H"
              ]
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9,
          "hidden": 1
        }
      },
      {
        "box": {
          "id": "lfo2shape_send",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            1975,
            180,
            22
          ],
          "text": "prepend lfo2shape",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "lfo2shape_send"
        }
      },
      {
        "box": {
          "id": "wave_router",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2000,
            180,
            22
          ],
          "text": "route a b c d",
          "numinlets": 1,
          "numoutlets": 5,
          "varname": "wave_router"
        }
      },
      {
        "box": {
          "id": "drop_a",
          "maxclass": "live.drop",
          "patching_rect": [
            405,
            29,
            66,
            60
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            29,
            66,
            60
          ],
          "varname": "drop_a",
          "legend": "A / DROP",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "decodemode": 1,
          "textcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "bordercolor": [
            0.25,
            0.4,
            0.43,
            1
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "A Sample",
              "parameter_shortname": "A Sample",
              "parameter_type": 4,
              "parameter_invisible": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "dropsend_a",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2025,
            180,
            22
          ],
          "text": "prepend path a",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dropsend_a"
        }
      },
      {
        "box": {
          "id": "wave_a",
          "maxclass": "waveform~",
          "patching_rect": [
            476,
            29,
            238,
            37
          ],
          "presentation": 1,
          "presentation_rect": [
            476,
            29,
            238,
            37
          ],
          "varname": "wave_a",
          "buffername": "#0-a",
          "setmode": 1,
          "outmode": 3,
          "allowdrag": 0,
          "numinlets": 5,
          "numoutlets": 6,
          "bgcolor": [
            0.08,
            0.12,
            0.15,
            1
          ],
          "waveformcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "selectioncolor": [
            0.48,
            0.65,
            1,
            1
          ],
          "selectalpha": 0.3
        }
      },
      {
        "box": {
          "id": "select_a",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2050,
            180,
            22
          ],
          "text": "prepend selection a",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "select_a"
        }
      },
      {
        "box": {
          "id": "alevel",
          "maxclass": "live.dial",
          "patching_rect": [
            721,
            32,
            64,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            721,
            32,
            64,
            48
          ],
          "varname": "alevel",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "A Level",
              "parameter_shortname": "A Level",
              "parameter_type": 0,
              "parameter_mmin": -70,
              "parameter_mmax": 6,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4,
              "parameter_modmode": 2,
              "parameter_units": "dB"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "alevel_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2075,
            180,
            22
          ],
          "text": "prepend alevel",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "alevel_send"
        }
      },
      {
        "box": {
          "id": "label_astart",
          "maxclass": "comment",
          "patching_rect": [
            476,
            71,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            476,
            71,
            29,
            16
          ],
          "text": "IN",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_astart"
        }
      },
      {
        "box": {
          "id": "astart",
          "maxclass": "live.numbox",
          "patching_rect": [
            506,
            69,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            506,
            69,
            81,
            19
          ],
          "varname": "astart",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "A Start",
              "parameter_shortname": "A Start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "astart_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2100,
            180,
            22
          ],
          "text": "prepend astart",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "astart_send"
        }
      },
      {
        "box": {
          "id": "region_astart",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2125,
            180,
            22
          ],
          "text": "prepend region a start",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_astart"
        }
      },
      {
        "box": {
          "id": "label_aend",
          "maxclass": "comment",
          "patching_rect": [
            599,
            71,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            599,
            71,
            29,
            16
          ],
          "text": "OUT",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_aend"
        }
      },
      {
        "box": {
          "id": "aend",
          "maxclass": "live.numbox",
          "patching_rect": [
            629,
            69,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            629,
            69,
            81,
            19
          ],
          "varname": "aend",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "A End",
              "parameter_shortname": "A End",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "aend_send",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2150,
            180,
            22
          ],
          "text": "prepend aend",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "aend_send"
        }
      },
      {
        "box": {
          "id": "region_aend",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2175,
            180,
            22
          ],
          "text": "prepend region a end",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_aend"
        }
      },
      {
        "box": {
          "id": "buffer_a",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2200,
            180,
            22
          ],
          "text": "buffer~ @embed 0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "buffer_a"
        }
      },
      {
        "box": {
          "id": "info_a",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2225,
            180,
            22
          ],
          "text": "info~",
          "numinlets": 1,
          "numoutlets": 10,
          "varname": "info_a"
        }
      },
      {
        "box": {
          "id": "sr_a",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2250,
            180,
            22
          ],
          "text": "prepend sra",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "sr_a"
        }
      },
      {
        "box": {
          "id": "loaded_a",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2275,
            180,
            22
          ],
          "text": "prepend loaded a",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "loaded_a"
        }
      },
      {
        "box": {
          "id": "duration_a",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2300,
            180,
            22
          ],
          "text": "prepend duration a",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "duration_a"
        }
      },
      {
        "box": {
          "id": "drop_b",
          "maxclass": "live.drop",
          "patching_rect": [
            795,
            29,
            66,
            60
          ],
          "presentation": 1,
          "presentation_rect": [
            795,
            29,
            66,
            60
          ],
          "varname": "drop_b",
          "legend": "B / DROP",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "decodemode": 1,
          "textcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "bordercolor": [
            0.25,
            0.4,
            0.43,
            1
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "B Sample",
              "parameter_shortname": "B Sample",
              "parameter_type": 4,
              "parameter_invisible": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "dropsend_b",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2325,
            180,
            22
          ],
          "text": "prepend path b",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dropsend_b"
        }
      },
      {
        "box": {
          "id": "wave_b",
          "maxclass": "waveform~",
          "patching_rect": [
            866,
            29,
            238,
            37
          ],
          "presentation": 1,
          "presentation_rect": [
            866,
            29,
            238,
            37
          ],
          "varname": "wave_b",
          "buffername": "#0-b",
          "setmode": 1,
          "outmode": 3,
          "allowdrag": 0,
          "numinlets": 5,
          "numoutlets": 6,
          "bgcolor": [
            0.08,
            0.12,
            0.15,
            1
          ],
          "waveformcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "selectioncolor": [
            0.48,
            0.65,
            1,
            1
          ],
          "selectalpha": 0.3
        }
      },
      {
        "box": {
          "id": "select_b",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2350,
            180,
            22
          ],
          "text": "prepend selection b",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "select_b"
        }
      },
      {
        "box": {
          "id": "blevel",
          "maxclass": "live.dial",
          "patching_rect": [
            1111,
            32,
            64,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            1111,
            32,
            64,
            48
          ],
          "varname": "blevel",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "B Level",
              "parameter_shortname": "B Level",
              "parameter_type": 0,
              "parameter_mmin": -70,
              "parameter_mmax": 6,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4,
              "parameter_modmode": 2,
              "parameter_units": "dB"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "blevel_send",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2375,
            180,
            22
          ],
          "text": "prepend blevel",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "blevel_send"
        }
      },
      {
        "box": {
          "id": "label_bstart",
          "maxclass": "comment",
          "patching_rect": [
            866,
            71,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            866,
            71,
            29,
            16
          ],
          "text": "IN",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_bstart"
        }
      },
      {
        "box": {
          "id": "bstart",
          "maxclass": "live.numbox",
          "patching_rect": [
            896,
            69,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            896,
            69,
            81,
            19
          ],
          "varname": "bstart",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "B Start",
              "parameter_shortname": "B Start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "bstart_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2400,
            180,
            22
          ],
          "text": "prepend bstart",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "bstart_send"
        }
      },
      {
        "box": {
          "id": "region_bstart",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2425,
            180,
            22
          ],
          "text": "prepend region b start",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_bstart"
        }
      },
      {
        "box": {
          "id": "label_bend",
          "maxclass": "comment",
          "patching_rect": [
            989,
            71,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            989,
            71,
            29,
            16
          ],
          "text": "OUT",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_bend"
        }
      },
      {
        "box": {
          "id": "bend",
          "maxclass": "live.numbox",
          "patching_rect": [
            1019,
            69,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            1019,
            69,
            81,
            19
          ],
          "varname": "bend",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "B End",
              "parameter_shortname": "B End",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "bend_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2450,
            180,
            22
          ],
          "text": "prepend bend",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "bend_send"
        }
      },
      {
        "box": {
          "id": "region_bend",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2475,
            180,
            22
          ],
          "text": "prepend region b end",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_bend"
        }
      },
      {
        "box": {
          "id": "buffer_b",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2500,
            180,
            22
          ],
          "text": "buffer~ @embed 0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "buffer_b"
        }
      },
      {
        "box": {
          "id": "info_b",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2525,
            180,
            22
          ],
          "text": "info~",
          "numinlets": 1,
          "numoutlets": 10,
          "varname": "info_b"
        }
      },
      {
        "box": {
          "id": "sr_b",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2550,
            180,
            22
          ],
          "text": "prepend srb",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "sr_b"
        }
      },
      {
        "box": {
          "id": "loaded_b",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2575,
            180,
            22
          ],
          "text": "prepend loaded b",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "loaded_b"
        }
      },
      {
        "box": {
          "id": "duration_b",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2600,
            180,
            22
          ],
          "text": "prepend duration b",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "duration_b"
        }
      },
      {
        "box": {
          "id": "drop_c",
          "maxclass": "live.drop",
          "patching_rect": [
            405,
            98,
            66,
            60
          ],
          "presentation": 1,
          "presentation_rect": [
            405,
            98,
            66,
            60
          ],
          "varname": "drop_c",
          "legend": "C / DROP",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "decodemode": 1,
          "textcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "bordercolor": [
            0.25,
            0.4,
            0.43,
            1
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "C Sample",
              "parameter_shortname": "C Sample",
              "parameter_type": 4,
              "parameter_invisible": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "dropsend_c",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2625,
            180,
            22
          ],
          "text": "prepend path c",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dropsend_c"
        }
      },
      {
        "box": {
          "id": "wave_c",
          "maxclass": "waveform~",
          "patching_rect": [
            476,
            98,
            238,
            37
          ],
          "presentation": 1,
          "presentation_rect": [
            476,
            98,
            238,
            37
          ],
          "varname": "wave_c",
          "buffername": "#0-c",
          "setmode": 1,
          "outmode": 3,
          "allowdrag": 0,
          "numinlets": 5,
          "numoutlets": 6,
          "bgcolor": [
            0.08,
            0.12,
            0.15,
            1
          ],
          "waveformcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "selectioncolor": [
            0.48,
            0.65,
            1,
            1
          ],
          "selectalpha": 0.3
        }
      },
      {
        "box": {
          "id": "select_c",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2650,
            180,
            22
          ],
          "text": "prepend selection c",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "select_c"
        }
      },
      {
        "box": {
          "id": "clevel",
          "maxclass": "live.dial",
          "patching_rect": [
            721,
            101,
            64,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            721,
            101,
            64,
            48
          ],
          "varname": "clevel",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "C Level",
              "parameter_shortname": "C Level",
              "parameter_type": 0,
              "parameter_mmin": -70,
              "parameter_mmax": 6,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4,
              "parameter_modmode": 2,
              "parameter_units": "dB"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "clevel_send",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2675,
            180,
            22
          ],
          "text": "prepend clevel",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "clevel_send"
        }
      },
      {
        "box": {
          "id": "label_cstart",
          "maxclass": "comment",
          "patching_rect": [
            476,
            140,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            476,
            140,
            29,
            16
          ],
          "text": "IN",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_cstart"
        }
      },
      {
        "box": {
          "id": "cstart",
          "maxclass": "live.numbox",
          "patching_rect": [
            506,
            138,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            506,
            138,
            81,
            19
          ],
          "varname": "cstart",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "C Start",
              "parameter_shortname": "C Start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "cstart_send",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2700,
            180,
            22
          ],
          "text": "prepend cstart",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "cstart_send"
        }
      },
      {
        "box": {
          "id": "region_cstart",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2725,
            180,
            22
          ],
          "text": "prepend region c start",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_cstart"
        }
      },
      {
        "box": {
          "id": "label_cend",
          "maxclass": "comment",
          "patching_rect": [
            599,
            140,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            599,
            140,
            29,
            16
          ],
          "text": "OUT",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_cend"
        }
      },
      {
        "box": {
          "id": "cend",
          "maxclass": "live.numbox",
          "patching_rect": [
            629,
            138,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            629,
            138,
            81,
            19
          ],
          "varname": "cend",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "C End",
              "parameter_shortname": "C End",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "cend_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2750,
            180,
            22
          ],
          "text": "prepend cend",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "cend_send"
        }
      },
      {
        "box": {
          "id": "region_cend",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            2775,
            180,
            22
          ],
          "text": "prepend region c end",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_cend"
        }
      },
      {
        "box": {
          "id": "buffer_c",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2800,
            180,
            22
          ],
          "text": "buffer~ @embed 0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "buffer_c"
        }
      },
      {
        "box": {
          "id": "info_c",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            2825,
            180,
            22
          ],
          "text": "info~",
          "numinlets": 1,
          "numoutlets": 10,
          "varname": "info_c"
        }
      },
      {
        "box": {
          "id": "sr_c",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2850,
            180,
            22
          ],
          "text": "prepend src",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "sr_c"
        }
      },
      {
        "box": {
          "id": "loaded_c",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            2875,
            180,
            22
          ],
          "text": "prepend loaded c",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "loaded_c"
        }
      },
      {
        "box": {
          "id": "duration_c",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2900,
            180,
            22
          ],
          "text": "prepend duration c",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "duration_c"
        }
      },
      {
        "box": {
          "id": "drop_d",
          "maxclass": "live.drop",
          "patching_rect": [
            795,
            98,
            66,
            60
          ],
          "presentation": 1,
          "presentation_rect": [
            795,
            98,
            66,
            60
          ],
          "varname": "drop_d",
          "legend": "D / DROP",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "decodemode": 1,
          "textcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "bordercolor": [
            0.25,
            0.4,
            0.43,
            1
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "D Sample",
              "parameter_shortname": "D Sample",
              "parameter_type": 4,
              "parameter_invisible": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "dropsend_d",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            2925,
            180,
            22
          ],
          "text": "prepend path d",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dropsend_d"
        }
      },
      {
        "box": {
          "id": "wave_d",
          "maxclass": "waveform~",
          "patching_rect": [
            866,
            98,
            238,
            37
          ],
          "presentation": 1,
          "presentation_rect": [
            866,
            98,
            238,
            37
          ],
          "varname": "wave_d",
          "buffername": "#0-d",
          "setmode": 1,
          "outmode": 3,
          "allowdrag": 0,
          "numinlets": 5,
          "numoutlets": 6,
          "bgcolor": [
            0.08,
            0.12,
            0.15,
            1
          ],
          "waveformcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "selectioncolor": [
            0.48,
            0.65,
            1,
            1
          ],
          "selectalpha": 0.3
        }
      },
      {
        "box": {
          "id": "select_d",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            2950,
            180,
            22
          ],
          "text": "prepend selection d",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "select_d"
        }
      },
      {
        "box": {
          "id": "dlevel",
          "maxclass": "live.dial",
          "patching_rect": [
            1111,
            101,
            64,
            48
          ],
          "presentation": 1,
          "presentation_rect": [
            1111,
            101,
            64,
            48
          ],
          "varname": "dlevel",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "D Level",
              "parameter_shortname": "D Level",
              "parameter_type": 0,
              "parameter_mmin": -70,
              "parameter_mmax": 6,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 4,
              "parameter_modmode": 2,
              "parameter_units": "dB"
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "dlevel_send",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            2975,
            180,
            22
          ],
          "text": "prepend dlevel",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dlevel_send"
        }
      },
      {
        "box": {
          "id": "label_dstart",
          "maxclass": "comment",
          "patching_rect": [
            866,
            140,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            866,
            140,
            29,
            16
          ],
          "text": "IN",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_dstart"
        }
      },
      {
        "box": {
          "id": "dstart",
          "maxclass": "live.numbox",
          "patching_rect": [
            896,
            138,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            896,
            138,
            81,
            19
          ],
          "varname": "dstart",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "D Start",
              "parameter_shortname": "D Start",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "dstart_send",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            3000,
            180,
            22
          ],
          "text": "prepend dstart",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dstart_send"
        }
      },
      {
        "box": {
          "id": "region_dstart",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            3025,
            180,
            22
          ],
          "text": "prepend region d start",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_dstart"
        }
      },
      {
        "box": {
          "id": "label_dend",
          "maxclass": "comment",
          "patching_rect": [
            989,
            140,
            29,
            16
          ],
          "presentation": 1,
          "presentation_rect": [
            989,
            140,
            29,
            16
          ],
          "text": "OUT",
          "fontsize": 9,
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "varname": "label_dend"
        }
      },
      {
        "box": {
          "id": "dend",
          "maxclass": "live.numbox",
          "patching_rect": [
            1019,
            138,
            81,
            19
          ],
          "presentation": 1,
          "presentation_rect": [
            1019,
            138,
            81,
            19
          ],
          "varname": "dend",
          "parameter_enable": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "D End",
              "parameter_shortname": "D End",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1,
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_unitstyle": 1,
              "parameter_modmode": 2
            }
          },
          "activebgcolor": [
            0.34,
            0.86,
            0.75,
            1
          ],
          "textcolor": [
            0.85,
            0.9,
            0.94,
            1
          ],
          "fontsize": 9
        }
      },
      {
        "box": {
          "id": "dend_send",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            3050,
            180,
            22
          ],
          "text": "prepend dend",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "dend_send"
        }
      },
      {
        "box": {
          "id": "region_dend",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            3075,
            180,
            22
          ],
          "text": "prepend region d end",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "region_dend"
        }
      },
      {
        "box": {
          "id": "buffer_d",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            3100,
            180,
            22
          ],
          "text": "buffer~ @embed 0",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "buffer_d"
        }
      },
      {
        "box": {
          "id": "info_d",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            3125,
            180,
            22
          ],
          "text": "info~",
          "numinlets": 1,
          "numoutlets": 10,
          "varname": "info_d"
        }
      },
      {
        "box": {
          "id": "sr_d",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            3150,
            180,
            22
          ],
          "text": "prepend srd",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "sr_d"
        }
      },
      {
        "box": {
          "id": "loaded_d",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            3175,
            180,
            22
          ],
          "text": "prepend loaded d",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "loaded_d"
        }
      },
      {
        "box": {
          "id": "duration_d",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            3200,
            180,
            22
          ],
          "text": "prepend duration d",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "duration_d"
        }
      },
      {
        "box": {
          "id": "init",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            3225,
            180,
            22
          ],
          "text": "loadbang",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "init"
        }
      },
      {
        "box": {
          "id": "delayinit",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            3250,
            180,
            22
          ],
          "text": "deferlow",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "delayinit"
        }
      },
      {
        "box": {
          "id": "liveinit",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            3275,
            180,
            22
          ],
          "text": "live.thisdevice",
          "numinlets": 1,
          "numoutlets": 3,
          "varname": "liveinit"
        }
      },
      {
        "box": {
          "id": "savestate",
          "maxclass": "newobj",
          "patching_rect": [
            390,
            3300,
            180,
            22
          ],
          "text": "autopattr @autorestore 1",
          "numinlets": 1,
          "numoutlets": 1,
          "varname": "savestate"
        }
      },
      {
        "box": {
          "id": "device",
          "maxclass": "newobj",
          "patching_rect": [
            575,
            3325,
            180,
            22
          ],
          "text": "live.banks",
          "numinlets": 1,
          "numoutlets": 2,
          "varname": "device"
        }
      },
      {
        "box": {
          "id": "fullpath_a",
          "maxclass": "newobj",
          "patching_rect": [
            760,
            3350,
            180,
            22
          ],
          "text": "prepend fullpath a",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "fullpath_b",
          "maxclass": "newobj",
          "patching_rect": [
            945,
            3375,
            180,
            22
          ],
          "text": "prepend fullpath b",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "fullpath_c",
          "maxclass": "newobj",
          "patching_rect": [
            20,
            3400,
            180,
            22
          ],
          "text": "prepend fullpath c",
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "fullpath_d",
          "maxclass": "newobj",
          "patching_rect": [
            205,
            3425,
            180,
            22
          ],
          "text": "prepend fullpath d",
          "numinlets": 1,
          "numoutlets": 1
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "feedback_record_on",
            0
          ],
          "destination": [
            "feedback_record",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            0
          ],
          "destination": [
            "feedback_sum_l",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            1
          ],
          "destination": [
            "feedback_sum_r",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regrain_engine",
            0
          ],
          "destination": [
            "regrain_send_l",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regrain_engine",
            1
          ],
          "destination": [
            "regrain_send_r",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regrain_return_l",
            0
          ],
          "destination": [
            "feedback_sum_l",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regrain_return_r",
            0
          ],
          "destination": [
            "feedback_sum_r",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_sum_l",
            0
          ],
          "destination": [
            "feedback_clip_l",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_sum_r",
            0
          ],
          "destination": [
            "feedback_clip_r",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_clip_l",
            0
          ],
          "destination": [
            "feedback_record",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_clip_r",
            0
          ],
          "destination": [
            "feedback_record",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_sum_l",
            0
          ],
          "destination": [
            "freeze_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_sum_r",
            0
          ],
          "destination": [
            "freeze_engine",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "audioin",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "audioin",
            1
          ],
          "destination": [
            "engine",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeze_engine",
            0
          ],
          "destination": [
            "audioout",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeze_engine",
            1
          ],
          "destination": [
            "audioout",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            2
          ],
          "destination": [
            "meters",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "meters",
            0
          ],
          "destination": [
            "actmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "actmsg",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "regrain_engine",
            2
          ],
          "destination": [
            "remeter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "remeter",
            0
          ],
          "destination": [
            "remsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "remsg",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "engine",
            3
          ],
          "destination": [
            "scanmeter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "scanmeter",
            0
          ],
          "destination": [
            "scmsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "scmsg",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "controller",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "controller",
            0
          ],
          "destination": [
            "feedback_name_route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_name_route",
            0
          ],
          "destination": [
            "feedback_name_prepend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_name_prepend",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pad",
            0
          ],
          "destination": [
            "padx",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pad",
            1
          ],
          "destination": [
            "pady",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "padx",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pady",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphx",
            0
          ],
          "destination": [
            "morphx_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphx_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphx",
            0
          ],
          "destination": [
            "morphx_ui",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphx_ui",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphy",
            0
          ],
          "destination": [
            "morphy_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphy_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphy",
            0
          ],
          "destination": [
            "morphy_ui",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "morphy_ui",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "run",
            0
          ],
          "destination": [
            "run_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "run_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeze",
            0
          ],
          "destination": [
            "freeze_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeze_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "output",
            0
          ],
          "destination": [
            "output_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "output_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "macro",
            0
          ],
          "destination": [
            "macro_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "macro_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "page",
            0
          ],
          "destination": [
            "page_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "page_send",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "size",
            0
          ],
          "destination": [
            "size_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "size_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density",
            0
          ],
          "destination": [
            "density_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amount",
            0
          ],
          "destination": [
            "amount_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "amount_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitch",
            0
          ],
          "destination": [
            "pitch_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitch_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "position",
            0
          ],
          "destination": [
            "position_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "position_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "scan",
            0
          ],
          "destination": [
            "scan_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "scan_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate",
            0
          ],
          "destination": [
            "rate_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reverse",
            0
          ],
          "destination": [
            "reverse_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reverse_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shape",
            0
          ],
          "destination": [
            "shape_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shape_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bias",
            0
          ],
          "destination": [
            "bias_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bias_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cutoff",
            0
          ],
          "destination": [
            "cutoff_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cutoff_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "resonance",
            0
          ],
          "destination": [
            "resonance_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "resonance_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback",
            0
          ],
          "destination": [
            "feedback_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdelay",
            0
          ],
          "destination": [
            "fbdelay_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdelay_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "spray",
            0
          ],
          "destination": [
            "spray_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "spray_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sizej",
            0
          ],
          "destination": [
            "sizej_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sizej_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "densityj",
            0
          ],
          "destination": [
            "densityj_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "densityj_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitchj",
            0
          ],
          "destination": [
            "pitchj_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitchj_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pan",
            0
          ],
          "destination": [
            "pan_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pan_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "spread",
            0
          ],
          "destination": [
            "spread_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "spread_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filterj",
            0
          ],
          "destination": [
            "filterj_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filterj_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "inputgain",
            0
          ],
          "destination": [
            "inputgain_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "inputgain_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbsize",
            0
          ],
          "destination": [
            "fbsize_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbsize_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdensity",
            0
          ],
          "destination": [
            "fbdensity_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdensity_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbpitch",
            0
          ],
          "destination": [
            "fbpitch_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbpitch_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filtermode",
            0
          ],
          "destination": [
            "filtermode_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "filtermode_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1rate",
            0
          ],
          "destination": [
            "lfo1rate_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1rate_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1depth",
            0
          ],
          "destination": [
            "lfo1depth_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1depth_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1dest",
            0
          ],
          "destination": [
            "lfo1dest_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1dest_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1shape",
            0
          ],
          "destination": [
            "lfo1shape_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo1shape_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2rate",
            0
          ],
          "destination": [
            "lfo2rate_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2rate_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2depth",
            0
          ],
          "destination": [
            "lfo2depth_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2depth_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2dest",
            0
          ],
          "destination": [
            "lfo2dest_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2dest_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2shape",
            0
          ],
          "destination": [
            "lfo2shape_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "lfo2shape_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "controller",
            1
          ],
          "destination": [
            "wave_router",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "drop_a",
            0
          ],
          "destination": [
            "dropsend_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dropsend_a",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_a",
            5
          ],
          "destination": [
            "select_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "select_a",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "alevel",
            0
          ],
          "destination": [
            "alevel_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "alevel_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "astart",
            0
          ],
          "destination": [
            "astart_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "astart_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "astart",
            0
          ],
          "destination": [
            "region_astart",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_astart",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aend",
            0
          ],
          "destination": [
            "aend_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aend_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "aend",
            0
          ],
          "destination": [
            "region_aend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_aend",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "buffer_a",
            1
          ],
          "destination": [
            "info_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_a",
            0
          ],
          "destination": [
            "sr_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sr_a",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_a",
            7
          ],
          "destination": [
            "loaded_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded_a",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_a",
            6
          ],
          "destination": [
            "duration_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "duration_a",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_router",
            0
          ],
          "destination": [
            "wave_a",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "drop_b",
            0
          ],
          "destination": [
            "dropsend_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dropsend_b",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_b",
            5
          ],
          "destination": [
            "select_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "select_b",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "blevel",
            0
          ],
          "destination": [
            "blevel_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "blevel_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bstart",
            0
          ],
          "destination": [
            "bstart_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bstart_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bstart",
            0
          ],
          "destination": [
            "region_bstart",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_bstart",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bend",
            0
          ],
          "destination": [
            "bend_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bend_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bend",
            0
          ],
          "destination": [
            "region_bend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_bend",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "buffer_b",
            1
          ],
          "destination": [
            "info_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_b",
            0
          ],
          "destination": [
            "sr_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sr_b",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_b",
            7
          ],
          "destination": [
            "loaded_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded_b",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_b",
            6
          ],
          "destination": [
            "duration_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "duration_b",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_router",
            1
          ],
          "destination": [
            "wave_b",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "drop_c",
            0
          ],
          "destination": [
            "dropsend_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dropsend_c",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_c",
            5
          ],
          "destination": [
            "select_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "select_c",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "clevel",
            0
          ],
          "destination": [
            "clevel_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "clevel_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cstart",
            0
          ],
          "destination": [
            "cstart_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cstart_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cstart",
            0
          ],
          "destination": [
            "region_cstart",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_cstart",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cend",
            0
          ],
          "destination": [
            "cend_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cend_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "cend",
            0
          ],
          "destination": [
            "region_cend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_cend",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "buffer_c",
            1
          ],
          "destination": [
            "info_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_c",
            0
          ],
          "destination": [
            "sr_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sr_c",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_c",
            7
          ],
          "destination": [
            "loaded_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded_c",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_c",
            6
          ],
          "destination": [
            "duration_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "duration_c",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_router",
            2
          ],
          "destination": [
            "wave_c",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "drop_d",
            0
          ],
          "destination": [
            "dropsend_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dropsend_d",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_d",
            5
          ],
          "destination": [
            "select_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "select_d",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dlevel",
            0
          ],
          "destination": [
            "dlevel_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dlevel_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dstart",
            0
          ],
          "destination": [
            "dstart_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dstart_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dstart",
            0
          ],
          "destination": [
            "region_dstart",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_dstart",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dend",
            0
          ],
          "destination": [
            "dend_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dend_send",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dend",
            0
          ],
          "destination": [
            "region_dend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "region_dend",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "buffer_d",
            1
          ],
          "destination": [
            "info_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_d",
            0
          ],
          "destination": [
            "sr_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sr_d",
            0
          ],
          "destination": [
            "engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_d",
            7
          ],
          "destination": [
            "loaded_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "loaded_d",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_d",
            6
          ],
          "destination": [
            "duration_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "duration_d",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "wave_router",
            3
          ],
          "destination": [
            "wave_d",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init",
            0
          ],
          "destination": [
            "delayinit",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "delayinit",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "liveinit",
            0
          ],
          "destination": [
            "delayinit",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "feedback_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdelay_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbsize_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbdensity_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fbpitch_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "size_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "density_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitch_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pitchj_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sizej_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "densityj_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rate_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reverse_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "pan_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "spread_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shape_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "bias_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "run_send",
            0
          ],
          "destination": [
            "regrain_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "freeze_send",
            0
          ],
          "destination": [
            "freeze_engine",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_a",
            9
          ],
          "destination": [
            "fullpath_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fullpath_a",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_b",
            9
          ],
          "destination": [
            "fullpath_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fullpath_b",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_c",
            9
          ],
          "destination": [
            "fullpath_c",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fullpath_c",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "info_d",
            9
          ],
          "destination": [
            "fullpath_d",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "fullpath_d",
            0
          ],
          "destination": [
            "controller",
            0
          ]
        }
      }
    ],
    "parameters": {
      "morphx": [
        "Morph X",
        "Morph X",
        0
      ],
      "morphy": [
        "Morph Y",
        "Morph Y",
        0
      ],
      "run": [
        "Run",
        "Run",
        0
      ],
      "freeze": [
        "Freeze",
        "Freeze",
        0
      ],
      "output": [
        "Output",
        "Output",
        0
      ],
      "macro": [
        "Macro Randomness",
        "Macro Randomness",
        0
      ],
      "page": [
        "Panel",
        "Panel",
        0
      ],
      "size": [
        "Grain Size",
        "Grain Size",
        0
      ],
      "density": [
        "Density",
        "Density",
        0
      ],
      "amount": [
        "Grain Amount",
        "Grain Amount",
        0
      ],
      "pitch": [
        "Pitch",
        "Pitch",
        0
      ],
      "position": [
        "Position",
        "Position",
        0
      ],
      "scan": [
        "Scan Speed",
        "Scan Speed",
        0
      ],
      "rate": [
        "Playback Rate",
        "Playback Rate",
        0
      ],
      "reverse": [
        "Reverse Prob",
        "Reverse Prob",
        0
      ],
      "shape": [
        "Envelope Shape",
        "Envelope Shape",
        0
      ],
      "bias": [
        "Attack Bias",
        "Attack Bias",
        0
      ],
      "cutoff": [
        "Grain Cutoff",
        "Grain Cutoff",
        0
      ],
      "resonance": [
        "Grain Q",
        "Grain Q",
        0
      ],
      "feedback": [
        "Feedback",
        "Feedback",
        0
      ],
      "fbdelay": [
        "Feedback Delay",
        "Feedback Delay",
        0
      ],
      "spray": [
        "Position Jitter",
        "Position Jitter",
        0
      ],
      "sizej": [
        "Size Random",
        "Size Random",
        0
      ],
      "densityj": [
        "Density Random",
        "Density Random",
        0
      ],
      "pitchj": [
        "Pitch Jitter",
        "Pitch Jitter",
        0
      ],
      "pan": [
        "Pan",
        "Pan",
        0
      ],
      "spread": [
        "Pan Spread",
        "Pan Spread",
        0
      ],
      "filterj": [
        "Filter Random",
        "Filter Random",
        0
      ],
      "inputgain": [
        "Input Capture",
        "Input Capture",
        0
      ],
      "fbsize": [
        "Regrain Size",
        "Regrain Size",
        0
      ],
      "fbdensity": [
        "Regrain Density",
        "Regrain Density",
        0
      ],
      "fbpitch": [
        "Regrain Pitch",
        "Regrain Pitch",
        0
      ],
      "filtermode": [
        "Filter Mode",
        "Filter Mode",
        0
      ],
      "lfo1rate": [
        "LFO 1 Rate",
        "LFO 1 Rate",
        0
      ],
      "lfo1depth": [
        "LFO 1 Depth",
        "LFO 1 Depth",
        0
      ],
      "lfo1dest": [
        "LFO 1 Target",
        "LFO 1 Target",
        0
      ],
      "lfo1shape": [
        "LFO 1 Shape",
        "LFO 1 Shape",
        0
      ],
      "lfo2rate": [
        "LFO 2 Rate",
        "LFO 2 Rate",
        0
      ],
      "lfo2depth": [
        "LFO 2 Depth",
        "LFO 2 Depth",
        0
      ],
      "lfo2dest": [
        "LFO 2 Target",
        "LFO 2 Target",
        0
      ],
      "lfo2shape": [
        "LFO 2 Shape",
        "LFO 2 Shape",
        0
      ],
      "drop_a": [
        "A Sample",
        "A Sample",
        0
      ],
      "alevel": [
        "A Level",
        "A Level",
        0
      ],
      "astart": [
        "A Start",
        "A Start",
        0
      ],
      "aend": [
        "A End",
        "A End",
        0
      ],
      "drop_b": [
        "B Sample",
        "B Sample",
        0
      ],
      "blevel": [
        "B Level",
        "B Level",
        0
      ],
      "bstart": [
        "B Start",
        "B Start",
        0
      ],
      "bend": [
        "B End",
        "B End",
        0
      ],
      "drop_c": [
        "C Sample",
        "C Sample",
        0
      ],
      "clevel": [
        "C Level",
        "C Level",
        0
      ],
      "cstart": [
        "C Start",
        "C Start",
        0
      ],
      "cend": [
        "C End",
        "C End",
        0
      ],
      "drop_d": [
        "D Sample",
        "D Sample",
        0
      ],
      "dlevel": [
        "D Level",
        "D Level",
        0
      ],
      "dstart": [
        "D Start",
        "D Start",
        0
      ],
      "dend": [
        "D End",
        "D End",
        0
      ],
      "parameterbanks": {
        "0": {
          "index": 0,
          "name": "Grain",
          "parameters": [
            "size",
            "density",
            "amount",
            "pitch",
            "position",
            "scan",
            "rate",
            "reverse"
          ]
        },
        "1": {
          "index": 1,
          "name": "Random",
          "parameters": [
            "macro",
            "spray",
            "pitchj",
            "sizej",
            "densityj",
            "spread",
            "pan",
            "freeze"
          ]
        },
        "2": {
          "index": 2,
          "name": "Tone",
          "parameters": [
            "shape",
            "bias",
            "cutoff",
            "resonance",
            "filtermode",
            "filterj",
            "feedback",
            "fbdelay"
          ]
        },
        "3": {
          "index": 3,
          "name": "Morph",
          "parameters": [
            "morphx",
            "morphy",
            "output",
            "run",
            "lfo1rate",
            "lfo1depth",
            "lfo2rate",
            "lfo2depth"
          ]
        }
      },
      "inherited_shortname": 1
    },
    "dependency_cache": [
      {
        "name": "quadra_resample_engine.gendsp",
        "type": "gDSP",
        "implicit": 1
      },
      {
        "name": "quadra_regrain_v3.gendsp",
        "type": "gDSP",
        "implicit": 1
      },
      {
        "name": "quadra_audio_freeze.gendsp",
        "type": "gDSP",
        "implicit": 1
      },
      {
        "name": "quadra_resample_ui.js",
        "type": "TEXT",
        "implicit": 1
      }
    ]
  }
}