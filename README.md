# Trading Strategy Analyzer

App made in matlab with an intuitive GUI for analysing trading strategy results from excel data. Code file names and GUI are in Spanish. 

Performs the statistical analysis of a strategy used to operate in the market. It's an app made for traders who daily operate in the market and want to analize all their strategy performance data. It analyzes the data of the operations carried out on one or more markets daily for one or several years and shows the statistical results both in graphs and in downloadable files (.txt) by the user. The file that the program is going to read must be of the excel type (.xlsx) and meet the conditions specified in the help on the home page.

### Requires Matlab Version 'R2020b' or higher

## Excel Format Required
To let the program analyze your excel data, this requirements must be satisfied by the .xlsx:

-   What format should the file to be uploaded have?

    To ensure correct data analysis, the selected sheet must have the year in position (1,1), all months must have 31 days and the same markets.

    Each monthly block must follow this pattern: A blank row that separates it from the previous month (If it is the first month in the upper cell of the blank row, the year must appear as specified before) and then a row with the 31 days of the month. From here you must write down the markets in which you have operated and the net monthly total, each one always occupying two rows, the one on the right being the net in euros and finally the accumulated total for the month

    In order to be able to analyze several years in a row, it is necessary that the final and initial accumulated figures of two years
    consecutive match exactly and must also have the same markets.

The excel needs to be in the same directory of the program. The program comes with an example excel ('EXAMPLE - ESTRATEGIA HAPAR.xlsx') that satisfies the requirements, and .txt downloaded examples ('Estadisticas_2019-2020_(17-Jan-2021).txt'). If two excel sheets with the same year are selected, the program will display an error of temporary inconsistency. Also, the excel sheets must be added in chronological order or the same error will be displayed

![Excel Image](/assets/excel.png) 

## Start the program
2 ways:
1. Execute the .exe if you are in windows (you don't need matlab to be installed in your computer)
2. Run the file 'InterfazUsuario.m' from the matlab environment
Once the program is openned, click on help 'Ayuda' to display information about the excel format that the program admits (already translated to english above). To load an excel file click on 'Buscar Archivo' and then select the file. Before analysing the data, click on the drop down list and select the sheets you want to be analyzed. Finally, click on the big button 'Analizar datos' to execute the analysis

GUI image            |  Loaded Excel Sheets
:-------------------------:|:-------------------------:
![](/assets/home.png) | ![](/assets/sheets.png)

Now if the excel is correct, another window will appear with some graphs. You can select the graphs you want to be plotted on and the statistics to calculate and show for each graph.

Analysis 1           |  Analysis 2 with stats
:-------------------------:|:-------------------------:
![](/assets/analysis1.png) | ![](/assets/analysis2.png)

Finally you can click on 'Informe' to show a new window with a complete analysis of each market that is present in your excel, and a global analysis combining all markets statistics. 

Report 1 - Global Report           |  Report 2 - Market 3
:-------------------------:|:-------------------------:
![](/assets/report1.png) | ![](/assets/report2.png)

Select 'Descargar' to download the report as a .txt file that will appear in the project directory
