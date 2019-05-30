Attribute VB_Name = "Module1"
Sub genSQL()
    Dim ash As Worksheet
    Dim insertString As String
    Dim dataObject As Object

    Set ash = ActiveSheet
    insertString = ""

    For Each rw In ash.Rows
        ' Skip empty cells
        If ash.Cells(rw.Row, 1).Value = "" Then
            Exit For
        End If

        ' Process only unapproved cells
        If ash.Cells(rw.Row, 9).Value = "" Then
            insertString = insertString & "INSERT INTO absences (employee_id, from_date, to_date, `type`, for_year, authorized_by, `status`, `description`)"
            insertString = insertString + " VALUES ("

            ' employee_id
            insertString = insertString & ash.Cells(rw.Row, 1) & ", "
            ' from_date
            insertString = insertString & "STR_TO_DATE('" & Format(ash.Cells(rw.Row, 2), "yyyy-MM-dd")
            insertString = insertString & " " & Format(ash.Cells(rw.Row, 3), "HH:mm") & "', '%Y-%m-%d %H:%i'), "
            ' to_date
            insertString = insertString & "STR_TO_DATE('" & Format(ash.Cells(rw.Row, 2), "yyyy-MM-dd")
            insertString = insertString & " " & Format(ash.Cells(rw.Row, 4), "HH:mm") & "', '%Y-%m-%d %H:%i'), "
            ' type
            insertString = insertString & "10, "
            ' for_year
            insertString = insertString & Format(ash.Cells(rw.Row, 2), "yyyy") & ", "
            ' authorized_by
            insertString = insertString & "1, "
            ' status
            insertString = insertString & "'Authorized'"
            ' description
            If ash.Cells(rw.Row, 3) > ash.Cells(rw.Row, 4) Then
                insertString = insertString & "'Offline: " & ash.Cells(rw.Row, 7) & "'"
            Else
                If ash.Cells(rw.Row, 7) = "Compensation with paid leave" Then
                    insertString = insertString & "'" & ash.Cells(rw.Row, 7) & "'"
                Else
                  insertString = insertString & "'Projects: " & ash.Cells(rw.Row, 7)
                  insertString = insertString & "; Tasks: " & ash.Cells(rw.Row, 8) & "'"
                End If
            End If

            insertString = insertString & ");" & vbCrLf
        End If
    Next rw

    ' Copy inserts to clipboard
    Set dataObject = CreateObject("new:{1C3B4210-F441-11CE-B9EA-00AA006B1A69}")
    dataObject.SetText insertString
    dataObject.PutInClipboard

    MsgBox ("Inserts copied to clipboard.")
End Sub
