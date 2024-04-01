
Процедура ЗадачаОтложеноITОтдел() Экспорт
	
	//Волков ИО 20.02.24 ++	 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(ДолжностиСотрудниковСрезПоследних.Период) КАК Период,
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТ_СотрудПериод
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|ГДЕ
	|	ДолжностиСотрудниковСрезПоследних.Подразделение = &ПодразделениеITОтдел
	|
	|СГРУППИРОВАТЬ ПО
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДолжностиСотрудниковСрезПоследних.Период КАК Период,
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	ДолжностиСотрудниковСрезПоследних.Подразделение КАК Подразделение,
	|	ДолжностиСотрудниковСрезПоследних.Сотрудник.Пользователь КАК СотрудникПользователь
	|ПОМЕСТИТЬ Актуал_СотрудникиОтдела
	|ИЗ
	|	РегистрСведений.ДолжностиСотрудников.СрезПоследних КАК ДолжностиСотрудниковСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СотрудПериод КАК ВТ_СотрудПериод
	|		ПО ДолжностиСотрудниковСрезПоследних.Сотрудник = ВТ_СотрудПериод.Сотрудник
	|			И ДолжностиСотрудниковСрезПоследних.Период = ВТ_СотрудПериод.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Задача.Ссылка КАК ЗадачаСсылка,
	|	Задача.Исполнитель КАК Исполнитель,
	|	Задача.Статус КАК Статус,
	|	Актуал_СотрудникиОтдела.СотрудникПользователь КАК СотрудникПользователь
	|ИЗ
	|	Актуал_СотрудникиОтдела КАК Актуал_СотрудникиОтдела
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Задача КАК Задача
	|		ПО Актуал_СотрудникиОтдела.СотрудникПользователь = Задача.Исполнитель
	|ГДЕ
	|	Задача.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗадач.ВРаботе)";

	Запрос.УстановитьПараметр("ПодразделениеITОтдел", Справочники.Подразделения.НайтиПоКоду("000000040")); 
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать(); 
	
	Пока РезультатЗапроса.Следующий() Цикл
		
		Исполнитель = РезультатЗапроса.Исполнитель;	
		
		ОбъектДокумента = РезультатЗапроса.ЗадачаСсылка.ПолучитьОбъект();
		ОбъектДокумента.Статус = Перечисления.СтатусыЗадач.Отложена;
		ОбъектДокумента.Записать();
		
	КонецЦикла;
	
КонецПроцедуры
