Pm_Message(status, data1, data2) = ((((data2) << 16) & 0xFF0000) | (((data1) << 8) & 0xFF00) | ((status) & 0xFF))
Pm_MessageStatus(msg) = ((msg) & 0xFF)
Pm_MessageData1(msg) = (((msg) >> 8) & 0xFF)
Pm_MessageData2(msg) = (((msg) >> 16) & 0xFF)

export Pm_Message, Pm_MessageStatus, Pm_MessageData1, Pm_MessageData2