dashboardPage(skin = "green",
              dashboardHeader(title = "Dự Đoán Giá Dịch Vụ"),
              dashboardSidebar(
                sidebarMenu(id = "sbm",
                  menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                  menuItem("Thị trường", tabName = "explorer", icon = icon("search")),
                  conditionalPanel(
                    condition = "input.sbm == 'valueAnalysis' || input.sbm == 'trainModels' || input.sbm == 'compareModels' || input.sbm == 'forecast'",
                    uiOutput("stateUi"),
                    uiOutput("countyUi"),
                    uiOutput("cityUi"),
                    uiOutput("zipUi")
                  ),
                  menuItem("Phân tích giá trị", tabName = "valueAnalysis", icon = icon("area-chart")),
                  menuItem("Dự đoán thị trường", tabName = "forecast", icon = icon("bar-chart"))
                )
              ),
              
              dashboardBody(
                includeCSS("www/custom.css"),
                tabItems(
                  tabItem(tabName = "dashboard",
                          fluidPage(
                            title = "Dashboard",
                            fluidRow(
                              column(width = 12,
                                valueBoxOutput("usViBox", width = 3),
                                valueBoxOutput("highestViBox", width = 3),
                                valueBoxOutput("usAnnualBox", width = 3),
                                valueBoxOutput("highestAnnualBox", width = 3)
                              )#end of column
                            ),# end of row
                            fluidRow(
                              column(width = 12,
                                     valueBoxOutput("numStatesBox", width = 3),
                                     valueBoxOutput("numCountiesBox", width = 3),
                                     valueBoxOutput("numCitiesBox", width = 3),
                                     valueBoxOutput("numZipsBox", width = 3)
                              )# end of column
                            ),# end of fluidrow
                            fluidRow(
                              column(width = 12,
                                box(
                                  title = "Top 10 tiểu bang theo mức giá dịch vụ du lịch hằng năm",
                                  status = "primary",
                                  width = 12,
                                  height = 255,
                                  solidHeader = FALSE,
                                  collapsible = TRUE,
                                  showOutput("top10StatesBar", "nvd3")
                                ),
                                box(
                                  title = "Top 10 thành phố theo mức giá dịch vụ du lịch hằng năm",
                                  status = "primary",
                                  width = 12,
                                  height = 255,
                                  solidHeader = FALSE,
                                  collapsible = TRUE,
                                  showOutput("top10CitiesBar", "nvd3")
                                ) #End of Box
                              ) # End of column
                          ), # End of Fluid Row
                          fluidRow(
                            column(width = 6,
                                   box(
                                     title = "Top 10 tiểu bang hàng theo chuỗi thời gian tăng trưởng giá trị du lịch",
                                     status = "primary",
                                     width = 12,
                                     solidHeader = FALSE,
                                     collapsible = TRUE,
                                     showOutput("top10StatesTS", "nvd3")
                                   ) #End of Box
                            ),# end of column
                            column(width = 6,
                                   box(
                                     title = "Top 10 thành phố theo chuỗi thời gian tăng trường giá trị du lich hằng năm",
                                     status = "primary",
                                     width = 12,
                                     solidHeader = FALSE,
                                     collapsible = TRUE,
                                     showOutput("top10CitiesTS", "nvd3")
                                   ) #End of Box
                            )# end of column
                          ),#end of fluidrow
                      ) # End of fluidPage
                  ), # End of tabItem
                  tabItem(tabName = "explorer",
                    fluidPage(
                      title = "Market Explorer",
                      column(width = 2,
                        box(
                           title = "Tìm kiếm",
                           status = "primary",
                           width = 12,
                           solidHeader = TRUE,
                           background = "navy",
                           box(
                             width = 12,
                             status = "primary",
                             solidHeader = FALSE,
                             background = "navy",
                             uiOutput("levelQueryUi")
                           ),# end of box
                           conditionalPanel(
                             condition = "input.analysisLevel == 2",
                             box(
                               status = "primary",
                               solidHeader = FALSE,
                               width = 12,
                               background = "navy",
                               uiOutput("stateQuery2Ui")
                             )# end of box
                           ),# end of conditional panel  
                           conditionalPanel(
                             condition = "input.analysisLevel == 3",
                             box(
                               status = "primary",
                               solidHeader = FALSE,
                               width = 12,
                               background = "navy",
                               uiOutput("stateQuery3Ui"),
                               uiOutput("countyQuery3Ui")
                             )# end of box
                           ),# end of conditionalpanel    
                           conditionalPanel(
                             condition = "input.analysisLevel == 4",
                             box(
                               status = "primary",
                               solidHeader = FALSE,
                               width = 12,
                               background = "navy",
                               uiOutput("stateQuery4Ui"),
                               uiOutput("countyQuery4Ui"),
                               uiOutput("cityQuery4Ui")
                             )# end of box
                           ),# end of conditionalpanel
                           box(
                             status = "primary",
                             solidHeader = FALSE,
                             width = 12,
                             background = "navy",
                             sliderInput("hviQuery", label = "Phạm vi giá trị ($000)", min = 0, max = 2000, value = c(0,1000)),
                             checkboxInput("maxValue", label = "Include all values exceeding $2m", value = FALSE)
                           ), # end of box
                           box(
                             status = "primary",
                             solidHeader = FALSE,
                             width = 12,
                             background = "navy",
                             selectInput("horizon", label = "Thời gian tăng trưởng:", 
                                         choices = c("Monthly", "Quarterly", "Annual", "5 Year", "10 Year"),
                                         selected = "Annual",
                                         selectize = FALSE),
                             numericInput("minGrowth", label = "Tốc độ tăng trưởng tối thiểu (%)", value = 1)
                           ),# end of box
                           actionButton("query", label = "Go") 
                        )# end of box
                      ),# end of column
                      conditionalPanel(
                        condition = "input.query",
                        column(width = 10,
                            box(
                              title = "Dữ liệu thị trường",
                              status = "primary",
                              width = 12,
                              solidHeader = TRUE,
                              collapsible = TRUE,
                              fluidRow(
                                column(width = 12,
                                  box(
                                    title = "Phân phối giá trị du lịch trung bình",
                                    status = "primary",
                                    width = 6,
                                    solidHeader = FALSE,
                                    collapsible = TRUE,
                                    plotOutput("valueHist")
                                  ),# end of box
                                  box(
                                    title = "Bảng thị trường",
                                    status = "primary",
                                    width = 6,
                                    solidHeader = FALSE,
                                    collapsible = TRUE,
                                    dataTableOutput("marketTbl")
                                  )# end of box
                                ),# end of column
                                column(width = 12,
                                       box(
                                         title = "Thị trường hàng đầu theo mức tăng trưởng",
                                         status = "primary",
                                         width = 12,
                                         height = 400,
                                         solidHeader = FALSE,
                                         collapsible = TRUE,
                                         showOutput("topByGrowth", "nvd3")
                                       )# end of box
                                )# end of column
                            ),# end of fluidRow
                            fluidRow(
                              box(
                                title = "Chuỗi thời gian giá trị du lịch trung bình cho các thị trường tăng trưởng hàng đầu",
                                status = "primary",
                                width = 12,
                                height = 700,
                                solidHeader = FALSE,
                                collapsible = TRUE,
                                showOutput("topMarketsTS", "nvd3")
                              ) #End of Box
                            )# end of fluidrow
                          )# end of box
                        )#end of column
                      ) # end of conditionalpanel
                    ) # End of fluidPage
                ), # End of tabItem 
                tabItem(tabName = "valueAnalysis",
                        fluidPage(
                          fluidRow(
                             box(
                               status = "primary",
                               title = "Bọ lọc chọn thi trường",
                               solidHeader = FALSE,
                               width = 3,
                               background = "navy",
                               p("Chọn một thị trường để phân tích, sau đó nhấn 'Go' để chạy phân tích"),
                               actionButton("analyze", label = "Go")
                             ),# end of box
                            conditionalPanel(
                              condition = "input.analyze",
                              valueBoxOutput("hviBox", width = 3),
                              valueBoxOutput("annualBox", width = 2),
                              valueBoxOutput("fiveYearBox", width = 2),
                              valueBoxOutput("tenYearBox", width = 2),
                              fluidRow(
                                column(width = 12,
                                  box(
                                    title = "Trang chủ giá trị khám phá theo chuỗi thời gian", status = "primary",
                                    solidHeader = TRUE, height = 800, width = 12,
                                    tabBox(
                                      title = "Phân rã chuỗi thời gian theo mùa và không theo mùa",
                                      id = "exploreTab", height = 660, width = 12,
                                      tabPanel("Không theo mùa", 
                                               box(
                                                 title = "Thứ tự kéo dài",
                                                 status = "success",
                                                 solidHeader = FALSE, width = 3,
                                                 p(
                                                   class = "text-muted",
                                                   paste("Adjust span order until the simple moving average has smoothed random fluctuations
                                                         and the trend component emerges")),
                                                 sliderInput("span", label = "Thứ tự kéo dài", min = 1, max = 10, value = 3, step = 1)
                                                   ),
                                               box(
                                                 title = "Ước tính Thành phần Xu hướng với Đường Trung bình Động Đơn giản (SMA)",
                                                 status = "success",
                                                 solidHeader = FALSE, height = 600, width = 9,
                                                 plotOutput("nsPlot")
                                               )# end of box
                                      ), # end of tabPanel
                                      tabPanel("Theo mùa", 
                                               box(
                                                 title = "Ước tính xu hướng theo mùa và các thành phần bất thường của chuỗi thời gian",
                                                 status = "success",
                                                 solidHeader = FALSE, height = 600, width = 12,
                                                 plotOutput("tsiPlot")
                                               )
                                      )# end of tab panel
                                    )# end of tabbox
                                  )# end of box
                                )# end of column
                              )#end of fluidrow
                            )# end of conditional panel
                          )# end of fluidrow
                        )#end of fluidPage
                ), # end of tabItem                  
                tabItem(tabName = "trainModels",
                        fluidPage(
                          column(width = 12,
                            fluidRow(
                              box(
                                title = "Model Training Parameters",
                                status = "primary", width = 12,
                                solidHeader = TRUE,
                                box(
                                  title = "Cross Validation",
                                  status = "primary", width = 3,
                                  solidHeader = FALSE,
                                  p(
                                    class = "text-muted",
                                    paste("The time series contains median housing prices, measured monthly, from 2000 thru 2015. Here, we
                            split the time series data into training and validation sets.  Indicate here, the end year for
                            the training set. The remaining years will be used to validate the predictions.")),
                                  sliderInput("split", label = "Training Set Split", min = 2004, max = 2014, value = 2014, step = 1)
                                ),# end of box
                                box(
                                  title = "Model Selection",
                                  status = "primary", width = 3,
                                  solidHeader = FALSE,
                                  p(
                                    class = "text-muted",
                                    paste("Select the forecast model algorithm.")),
                                  uiOutput("modelsUi")
                                ),# end of box
                                box(
                                  title = "Model Description",
                                  status = "primary", width = 6,
                                  solidHeader = FALSE,
                                  h3(textOutput("modelNameUi")),
                                  textOutput("modelDescUi"),
                                  br(),
                                  tags$strong("Please confirm that you have selected a market in the sidebar, then press 'Train Forecast Model' to train the selected model."),
                                  actionButton("train", label = "Train Forecast Model")
                                )# end of box
                              )# end of box
                          ),# end of fluidrow
                          conditionalPanel(
                            condition = "input.train",
                            fluidRow(
                              box(
                                title = "Prediction",
                                status = "primary", width = 7,
                                solidHeader = TRUE,
                                plotOutput("modelPlot", height = 460)
                              ),# end of box
                              box(
                                title = "Prediction Accuracy",
                                status = "primary", width = 5,
                                solidHeader = TRUE,
                                dataTableOutput("accuracy")
                              )# end of box
                            )# end of fluidrow
                          )# end of conditional panel
                      )# end of column
                    )# end of fluidPage
                ),# end of tabItem
                tabItem(tabName = "compareModels",
                        fluidPage(
                          fluidRow(
                             box(
                               status = "primary",
                               title = "Market Selector",
                               solidHeader = FALSE,
                               width = 3,
                               background = "navy",
                               p("Select a market to analyze, then press 'Go' to run the analysis"),
                               actionButton("compare", label = "Go")
                             ),# end of box
                            conditionalPanel(
                              condition = "input.compare",
                              valueBoxOutput("hviBox2", width = 3),
                              valueBoxOutput("annualBox2", width = 2),
                              valueBoxOutput("fiveYearBox2", width = 2),
                              valueBoxOutput("tenYearBox2", width = 2),
                              column(width = 12,
                                     fluidRow(
                                       box(
                                         status = "warning",
                                         width = 12,
                                         title = "Model Performance Summary",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         box(
                                           status = "warning",
                                           width = 6,
                                           title = "Model Performance Error Metrics",
                                           solidHeader = FALSE,
                                           selectInput("measurements", label = "Measurements", choices = 
                                                         c("ME: Mean Error" = "ME",
                                                           "RMSE: Root Mean Square Error" = "RMSE",
                                                           "MAE: Mean Absolute Error" = "MAE",
                                                           "MPE: Mean Percentage Error" = "MPE",
                                                           "MAPE: Mean Absolute Percentage Error" = "MAPE",
                                                           "MASE: Mean Absolute Scaled Error" = "MASE",
                                                           "ACF1: Autocorrelation of Errors at Lag 1" = "ACF1",
                                                           "Theil’s U" = "THEILS"),
                                                       multiple = FALSE, selectize = FALSE, selected = "MASE"),
                                           showOutput("measurementsBar", "nvd3")
                                         ),# end of box
                                         box(
                                           status = "warning",
                                           width = 6,
                                           title = "Model Performance Error Metrics",
                                           solidHeader = FALSE,
                                           dataTableOutput("modelsumm")
                                         )# end of box
                                       )# end of box
                                     ),#end of fluidrow
                                     fluidRow(
                                       box(
                                         status = "primary",
                                         width = 12,
                                         title = "Arima / ETS Model Performance",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                            box(
                                              status = "primary",
                                              width = 6,
                                              title = "Arima Model Performance",
                                              solidHeader = FALSE,
                                              plotOutput("arima")
                                            ),# end of box
                                            box(
                                              status = "primary",
                                              width = 6,
                                              title = "Exponential Smoothing (ETS) Model Performance",
                                              solidHeader = FALSE,
                                              plotOutput("ets")
                                            )# end of box
                                       )# end of box
                                     ),# end of fluidrow
                                     fluidRow(
                                       box(
                                         status = "primary",
                                         width = 12,
                                         title = "Naive / Neural Network Model Performance",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "Naive Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("naive")
                                         ),# end of box
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "Neural Network Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("neural")
                                         )# end of box
                                       )# end of box
                                     ),# end of fluidrow
                                     fluidRow(
                                       box(
                                         status = "primary",
                                         width = 12,
                                         title = "BATS / TBATS Model Performance",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "BATS Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("bats")
                                         ),# end of box
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "TBATS Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("tbats")
                                         )# end of box
                                       )# end of box
                                     ),# end of fluidrow
                                     fluidRow(
                                       box(
                                         status = "primary",
                                         width = 12,
                                         title = "STLM / STS Model Performance",
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "STLM Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("stlm")
                                         ),# end of box
                                         box(
                                           status = "primary",
                                           width = 6,
                                           title = "STS Model Performance",
                                           solidHeader = FALSE,
                                           plotOutput("sts")
                                         )# end of box
                                       )# end of box
                                     )# end of fluidrow
                              )# end of column
                        )# end of conditional panel
                    )# end of fluidrow
                  )# end of fluidPage
                ),# end of tabItem
                tabItem(tabName = "forecast",
                        fluidPage(
                          fluidRow(
                                 box(
                                   status = "primary",
                                   title = "Tùy chọn vào dự đoán",
                                   solidHeader = FALSE,
                                   width = 4,
                                   background = "navy",
                                   p("Chọn một thị trường để phân tích và số năm để dự báo, sau đó nhấn 'Go' để chạy phân tích"),
                                   sliderInput("forecastRange", label = NULL, min = 1, 
                                               max = 10, value = 5),
                                   actionButton("forecast", label = "Go")
                                 ),# end of box
                            conditionalPanel(
                              condition = "input.forecast",
                              column(width = 8,
                                     fluidRow(
                                       valueBoxOutput("minPredictionBox", width = 4),
                                       valueBoxOutput("maxPredictionBox", width = 4),
                                       valueBoxOutput("meanPredictionBox", width = 4)
                                     ),# end of fluidrow
                                     fluidRow(
                                       valueBoxOutput("BATSBox", width = 2),
                                       valueBoxOutput("TBATSBox", width = 2),
                                       valueBoxOutput("STLMBox", width = 2),
                                       valueBoxOutput("STSBox", width = 2)
                                     )# end of fluidrow
                               ),#end of column
                              column(width = 12,
                                   fluidRow(
                                     box(
                                       status = "primary",
                                       width = 12,
                                       title = "Tóm tắt dự đoán",
                                       solidHeader = TRUE,
                                       collapsible = TRUE,
                                       box(
                                         status = "primary",
                                         width = 8,
                                         height = 450,
                                         title = "Sơ đồ tóm tắt dự đoán",
                                         solidHeader = FALSE,
                                         tags$style(' {width: 900px}'),
                                         showOutput("forecastSummaryPlot", "nvd3")
                                       ),# end of box
                                       box(
                                         status = "primary",
                                         width = 4,
                                         height = 450,
                                         title = "Biểu đồ tóm tắt dự đoán",
                                         solidHeader = FALSE,
                                         showOutput("predictionPlot", "nvd3")
                                       )# end of box
                                     )# end of box
                                   ),# end of fluidrow
                                )# end of column
                              )# end of conditional panel
                          )# end of fluidrow
                        )# end of fluidPage
                      )# end of tabItem
          ) # end of tabITems
    )# end of dashboard body
)# end of dashboard page