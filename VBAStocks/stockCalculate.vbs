Sub stockCalculate()    ' Declare a variable to act as current worksheet, then loop through worksheets    Dim current As Worksheet        For Each current In Worksheets            'Activate the current worksheet to perform calculations        current.Activate        'Label Cells        Range("I1").Value = "Ticker"        Range("J1").Value = "Yearly Change"        Range("K1").Value = "Percent Change"        Range("L1").Value = "Total Stock Volume"                ' Set up needed variables        Dim i As Double        Dim j As Integer        Dim ticker As String        Dim yearOpen As Double        Dim totalVolume As Double                        'Assign initial values to variables        i = 2        j = 2        ticker = Range("A2").Value        yearOpen = Range("C2").Value        totalVolume = 0                        ' Loop through data        While Not IsEmpty(Cells(i, 1))                            'Check if the stock ticker changed during loop -- if so, we need to perform calculations            'on previous stock (since we've finished looping through stock)            If Cells(i, 1).Value <> ticker Then                            ' Place the finished stock in the ticker label column                Cells(j, 9).Value = ticker                                ' Substract opening year stock value from closing stock value to calculate difference                ' Place this difference in the appropriate column                Cells(j, 10).Value = Cells(i - 1, 6).Value - yearOpen                                If Cells(j, 10).Value < 0 Then                                        Cells(j, 10).Interior.Color = vbRed                                    ElseIf Cells(j, 10).Value > 0 Then                                    Cells(j, 10).Interior.Color = vbGreen                                    End If                                                ' Calculate the percent change. Use the yearly change value, divide by year open value,                ' multiply 100, and then round to two decimal places                ' Also making sure bad data (a yearOpen = 0, for instance) doesn't break code                                If yearOpen = 0 Then                    Cells(j, 11).Value = 0                Else                    Cells(j, 11).Value = Round(((Cells(j, 10).Value) / yearOpen) * 100, 2)                End If                                ' Place total volume in the proper column                Cells(j, 12).Value = totalVolume                                'Increment j if the stock changed                j = j + 1                                'Update variables for new stock                ticker = Cells(i, 1).Value                yearOpen = Cells(i, 3).Value                totalVolume = 0                        End If                        ' Keep track of volume            ' We perform this calculation after the if statement so if we enter a new stock,            ' total volume has been reset to 0            totalVolume = totalVolume + Cells(i, 7).Value                        ' Increment i            i = i + 1                Wend                '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''        ' Create max/min change and max volume rows                Dim maxChange As Double        Dim maxChangeRow As Integer        Dim maxChangeTicker As String        Dim minChange As Double        Dim minChangeRow As Integer        Dim minChangeTicker As String        Dim maxVolume As Double        Dim maxVolumeRow As Integer        Dim maxVolumeTicker As String                ' Format labeled cells        Cells(2, 15).Value = "Greatest % Increase"        Cells(3, 15).Value = "Greatest % Decrease"        Cells(4, 15).Value = "Greatest Total Volume"                Cells(1, 16).Value = "Ticker"        Cells(1, 17).Value = "Value"                        ' Use the final value of j from the loop to tell how many rows we added in our new columns        ' Subtract one from j because it would have incremented one farther than we wanted        ' We can use this method instead of looping through each row and doing a comparison between        ' the ongoing max value and each subsequent row... presumably it's faster        j = j - 1                maxChange = WorksheetFunction.Max(Range(Cells(2, 11), Cells(j, 11)))        minChange = WorksheetFunction.Min(Range(Cells(2, 11), Cells(j, 11)))        maxVolume = WorksheetFunction.Max(Range(Cells(2, 12), Cells(j, 12)))                ' This finds the value in our range -- indexed relative to the range given, not the worksheet rows        ' Thus we need to add 1 since our ranges start on the second row of the sheet        maxChangeRow = WorksheetFunction.Match(maxChange, Range(Cells(2, 11), Cells(j, 11)), 0) + 1        minChangeRow = WorksheetFunction.Match(minChange, Range(Cells(2, 11), Cells(j, 11)), 0) + 1        maxVolumeRow = WorksheetFunction.Match(maxVolume, Range(Cells(2, 12), Cells(j, 12)), 0) + 1                ' We can now use the row index to find the ticker associated with the values        maxChangeTicker = Cells(maxChangeRow, 9).Value        minChangeTicker = Cells(minChangeRow, 9).Value        maxVolumeTicker = Cells(maxVolumeRow, 9).Value                ' Enter our information        Cells(2, 16).Value = maxChangeTicker        Cells(2, 17).Value = maxChange                Cells(3, 16).Value = minChangeTicker        Cells(3, 17).Value = minChange                Cells(4, 16).Value = maxVolumeTicker        Cells(4, 17).Value = maxVolume                ' Debugging        MsgBox (current.Name)            NextEnd Sub