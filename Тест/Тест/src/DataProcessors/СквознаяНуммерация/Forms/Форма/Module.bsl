
&НаКлиенте
Процедура ПриНажатии(Команда) 			// ПРИ НАЖАТИИ САМ НАПИСАЛ ?????
	
	ПриНажатииНаСервере ();  

КонецПроцедуры


&НаСервере
Процедура ПриНажатииНаСервере ()
	
Запрос = Новый Запрос; 

Запрос.Текст = "ВЫБРАТЬ
|	КадровыйПриказ.Ссылка КАК Ссылка
|ИЗ
|	Документ.КадровыйПриказ КАК КадровыйПриказ
|
|УПОРЯДОЧИТЬ ПО 
|	КадровыйПриказ.Дата ВОЗР" ;  


	РезультатЗапроса = Запрос.Выполнить(); 	
	ВыборкаДокументов = РезультатЗапроса.Выбрать(); 

НовыйНомер = 0;

Пока ВыборкаДокументов.Следующий() Цикл 
	НовыйНомер = Число (НовыйНомер);
	НовыйНомер = НовыйНомер + 1; 
	
	НовыйНомер =  Формат(НовыйНомер, "ЧЦ=9; ЧВН=; ЧГ=0;") ;

	
	
	ДокОбъект = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
	ДокОбъект.Номер = НовыйНомер;
	ДокОбъект.Записать();
	
	
	
	
КонецЦикла; 

КонецПроцедуры






