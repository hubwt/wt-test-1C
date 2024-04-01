
Процедура ВыгрузитьБазы() Экспорт

	///+ГомзМА 19.10.2023
	ДанныеБаз = Новый ТаблицаЗначений;
	
	ДанныеБаз.Колонки.Добавить("ИмяИБ");
	ДанныеБаз.Колонки.Добавить("ЛогинИБ");
	ДанныеБаз.Колонки.Добавить("ПарольИБ");
	
	//Данные базы Ворктрак
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "worktruck";
	СтрокаТЗ.ЛогинИБ 	= "ГомзяковаМА";
	СтрокаТЗ.ПарольИБ 	= "4689";
	
	//Данные базы Ворктрак Света
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "worksvet";
	СтрокаТЗ.ЛогинИБ 	= "";
	СтрокаТЗ.ПарольИБ 	= "";

	//Данные базы Ворктрак Восстановление тягача
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "vostagach";
	СтрокаТЗ.ЛогинИБ 	= "";
	СтрокаТЗ.ПарольИБ 	= "";
	
	//Данные базы Керма Света
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "kermasvet";
	СтрокаТЗ.ЛогинИБ 	= "";
	СтрокаТЗ.ПарольИБ 	= "";
	
	//Данные базы Сервис Света
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "servisveta";
	СтрокаТЗ.ЛогинИБ 	= "";
	СтрокаТЗ.ПарольИБ 	= "";
	
	//Данные базы Технопарк Света
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "technosvet";
	СтрокаТЗ.ЛогинИБ 	= "";
	СтрокаТЗ.ПарольИБ 	= "";
	
	//Данные базы Банк
	СтрокаТЗ = ДанныеБаз.Добавить();
	СтрокаТЗ.ИмяИБ 		= "bank";
	СтрокаТЗ.ЛогинИБ 	= "Александр";
	СтрокаТЗ.ПарольИБ 	= "123456";
	
	
	Для каждого ДанныеБазы Из ДанныеБаз Цикл
		Коннектор = Новый COMобъект("V83.ComConnector");
		
		Агент = Коннектор.ConnectAgent("localhost");
		Кластер = Агент.GetClusters().GetValue(0);
		Агент.Authenticate(Кластер, "", "");
		
		Процессы = Агент.GetWorkingProcesses(Кластер);
		Для каждого РабочийПроцесс Из Процессы Цикл
			Если РабочийПроцесс.Running И РабочийПроцесс.IsEnable  Тогда
				СтрокаСоединенияСРабочимПроцессом = РабочийПроцесс.HostName + ":" + Формат(РабочийПроцесс.MainPort, "ЧГ=");
				СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(СтрокаСоединенияСРабочимПроцессом);
				СоединениеСРабочимПроцессом.AddAuthentication(ДанныеБазы.ЛогинИБ, ДанныеБазы.ПарольИБ);    
				базы = СоединениеСРабочимПроцессом.GetInfoBases();
				//запрещаем запуск регламентных заданий
				для каждого база из базы цикл
					Если база.name = ДанныеБазы.ИмяИБ тогда
						база.ScheduledJobsDenied = истина;
						СоединениеСРабочимПроцессом.UpdateInfoBase(база);
					КонецЕсли;    
				конецЦикла;        
				
				базы = Агент.GetInfoBases(Кластер);
				
				//обрубаем все соединения с бд
				для каждого база из базы цикл
					Если база.name = ДанныеБазы.ИмяИБ тогда
						Сеансы = Агент.GetInfoBaseSessions(Кластер, база);                
						Для каждого Сеанс Из Сеансы Цикл
							//Если Сеанс.AppID = "SrvrConsole" Тогда
							//    Продолжить;
							//КонецЕсли;
							Агент.TerminateSession(Кластер, Сеанс);    
							//Сообщить(Сеанс.AppID)
						КонецЦикла;                    
					КонецЕсли;    
				КонецЦикла;    
				
			КонецЕсли        
			
		КонецЦикла;    
		
		
		//делаем паузу 30сек
		КомандаWindows = "Timeout /T " + Строка(30) + " /NoBreak";
		ЗапуститьПриложение(КомандаWindows,,Истина);    
		
		текДата = ТекущаяДата();
		имяВремени = строка(День(текДата))+"_"+строка(месяц(текДата))+"_"+строка(год(текДата))
		+"_"+строка(Час(текДата))+"_"+строка(минута(текДата));
		имяВремени = СтрЗаменить(имяВремени,Символы.НПП,"");
		
		//запускаем выгрузку в .dt
		ЗапуститьПриложение("""C:\Program Files\1cv8\8.3.22.1750\bin\1cv8.exe"" CONFIG /S localhost\" + ДанныеБазы.ИмяИБ + " /N " + ДанныеБазы.ЛогинИБ + " /P" + ДанныеБазы.ПарольИБ + " /Out C:\Users\admin\Nextcloud\Backup\1c\" + ДанныеБазы.ИмяИБ + "\"
		+имяВремени+"_1c.log /DumpIB C:\Users\admin\Nextcloud\Backup\1c\" + ДанныеБазы.ИмяИБ + "\"+имяВремени+"_" + ДанныеБазы.ИмяИБ + ".dt",,истина);
		
		//делаем паузу 30сек
		КомандаWindows = "Timeout /T " + Строка(30) + " /NoBreak";
		ЗапуститьПриложение(КомандаWindows,,Истина);
		
		//разрешаем в бд запуск регл. заданий
		Коннектор = Новый COMобъект("V83.ComConnector");
		
		Агент = Коннектор.ConnectAgent("localhost");
		Кластер = Агент.GetClusters().GetValue(0);
		Агент.Authenticate(Кластер, "", "");
		
		Процессы = Агент.GetWorkingProcesses(Кластер);
		
		Для каждого РабочийПроцесс Из Процессы Цикл
			Если РабочийПроцесс.Running И РабочийПроцесс.IsEnable  Тогда
				СтрокаСоединенияСРабочимПроцессом = РабочийПроцесс.HostName + ":" + Формат(РабочийПроцесс.MainPort, "ЧГ=");
				СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(СтрокаСоединенияСРабочимПроцессом);
				СоединениеСРабочимПроцессом.AddAuthentication(ДанныеБазы.ЛогинИБ, ДанныеБазы.ПарольИБ);    
				базы = СоединениеСРабочимПроцессом.GetInfoBases();
				для каждого база из базы цикл
					Если база.name = ДанныеБазы.ИмяИБ тогда
						база.ScheduledJobsDenied = ложь;
						СоединениеСРабочимПроцессом.UpdateInfoBase(база);
					КонецЕсли;    
				конецЦикла;            
			КонецЕсли;    
		конецЦикла;            
		
		Коннектор = неопределено; 
		
	КонецЦикла;
	///-ГомзМА 19.10.2023

КонецПроцедуры