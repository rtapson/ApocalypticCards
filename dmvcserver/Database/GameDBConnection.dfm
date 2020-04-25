object MSSQLConnection: TMSSQLConnection
  OldCreateOrder = True
  Height = 198
  Width = 282
  object JBConnection: TAureliusConnection
    DriverName = 'MSSQL'
    Params.Strings = (
      'Server=.\'
      'Database=apcards'
      'TrustedConnection=True')
    Left = 64
    Top = 64
  end
end
