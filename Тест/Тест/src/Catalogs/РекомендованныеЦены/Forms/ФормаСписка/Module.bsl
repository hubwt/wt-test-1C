
&НаКлиенте
Процедура Поиск(Команда)
	// Вставить содержимое обработчика.
	RegExp = Новый COMОбъект("VBScript.RegExp");
         
	RegExp.IgnoreCase = Ложь; //Игнорировать регистр
	RegExp.Global = Истина; //Поиск всех вхождений шаблона
	RegExp.MultiLine = Истина; //Многострочный режим
			
	RegExp.Pattern = "\W";
	RegExp.Pattern = "[^a-zA-Zа-яА-Я_0-9]";
	стр1=RegExp.Replace( Поиск,"");  
	Номера = Новый Массив();
	Номера = НачатьПоиск2(стр1);
	RegExp = Новый COMОбъект("VBScript.RegExp");
	Фильтр(стр1, Номера);
КонецПроцедуры

&НаСервере
Функция Фильтр(Поиск1,Номера) Экспорт
	Перем а;
	Мас = РазбитьСтрокуНаМассивПодстрок(Поиск," ");
	Кол = Мас.Количество();
	Коды = Новый Массив();
	Запрос = Новый Запрос();
	ПоискПо = " ГДЕ СправочникНоменклатура.Код ПОДОБНО ""%"+Поиск+""" ИЛИ СправочникНоменклатура.Наименование ПОДОБНО ""%"+Поиск+"%"" ИЛИ СправочникНоменклатура.Артикул = """+Поиск+""" ИЛИ СправочникНоменклатура.НомерПроизводителя = """+Поиск+"""
	| ИЛИ СправочникНоменклатура.Код ПОДОБНО ""%"+Поиск1+""" ИЛИ СправочникНоменклатура.Наименование ПОДОБНО ""%"+Поиск1+"%"" ИЛИ СправочникНоменклатура.АртикулПоиск = """+Поиск1+""" ИЛИ СправочникНоменклатура.НомерПоиск = """+Поиск1+""" ИЛИ СправочникНоменклатура.Комплектность.Артикул= """+Поиск+""" ИЛИ СправочникНоменклатура.Комплектность.НомерПоиск= """+Поиск1+"""
    | ";
	Если Кол > 1 Тогда
		а=0;
		ПоискПо = ПоискПо + " ИЛИ ( ";
		Пока а < Кол Цикл
			Если а = 0 Тогда
				ПоискПо = ПоискПо + " СправочникНоменклатура.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			Иначе
				ПоискПо = ПоискПо + " И СправочникНоменклатура.Наименование ПОДОБНО ""%"+Мас[а]+"%""";
			КонецЕсли;
			а = а + 1;
		КонецЦикла;
		ПоискПо = ПоискПо + " ) ";
	КонецЕсли;
	
	Номера = УдалитьПовторяющиесяЭлементыМассива(Номера);
			
	Номер1 = Номера.Количество();
	Номер2 = 0;
	Пока Номер2 < Номер1 Цикл
		ПоискПо = ПоискПо + " ИЛИ СправочникНоменклатура.Артикул = """+Номера[Номер2]+""" ИЛИ СправочникНоменклатура.НомерПроизводителя = """+Номера[Номер2]+""" ИЛИ СправочникНоменклатура.Комплектность.Артикул= """+Номера[Номер2]+"""
		| ";
		Номер2 = Номер2 +1;
	КонецЦикла;
	Текст1 = 
	"	ВЫБРАТЬ
	| СправочникНоменклатура.Ссылка,
	| СправочникНоменклатура.ВерсияДанных,
	| СправочникНоменклатура.ПометкаУдаления,
	| СправочникНоменклатура.Предопределенный,
	| СправочникНоменклатура.Код,
	| СправочникНоменклатура.Наименование,
	| СправочникНоменклатура.Артикул,
	| СправочникНоменклатура.НомерПроизводителя,
	| СправочникНоменклатура.МестоНаСкладе,
	| СправочникНоменклатура.Бренд,
	| СправочникНоменклатура.АртикулПоиск,
	| СправочникНоменклатура.НомерПоиск,
	| СправочникНоменклатура.НаименованиеПолное,
	| РегистрНакопления1Остатки.КолвоОстаток,
	| СправочникНоменклатура.Комплектность.(
	| 	Ссылка,
	| 	НомерСтроки,
	| 	Артикул,
	| 	Наименование,
	| 	Количество,
	| 	Комментарий,
	| 	НомерПоиск
	| ),
	| СправочникНоменклатура.РекомендованаяЦена 
| ИЗ
	| Справочник.Номенклатура КАК СправочникНоменклатура
	| 	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	| 	ПО СправочникНоменклатура.Ссылка = РегистрНакопления1Остатки.Товар "+ ПоискПо;
	
	Список.ТекстЗапроса= Текст1;	
		 
КонецФункции


&НаСервере
Функция НачатьПоиск2(Поиск1) Экспорт 
// Вставить содержимое обработчика.
	ЭтоСкания = ЛОЖЬ;
	ЭтоЗамена = ЛОЖЬ;
	Запрос = Новый Запрос();
	Номера = Новый Массив();
	НомераВр = Новый Массив();
	Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	НомераСкания.Ссылка,
	 |	НомераСкания.Код КАК Код,
	 |	НомераСкания.Наименование,
	 |	НомераСкания.НомерСкания КАК НомерСкания,
	 |	НомераСкания.НомерЗамена КАК НомерЗамена,
	 |	НомераСкания.Представление
	 |ИЗ
	 |	Справочник.НомераСкания КАК НомераСкания
	 |ГДЕ
	 |	НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск 
	 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск1
	 |	ИЛИ НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск2
	 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск3
	 |УПОРЯДОЧИТЬ ПО Код";
	 Запрос.УстановитьПараметр("ПарамПоиск",Поиск);
	 Запрос.УстановитьПараметр("ПарамПоиск1","%/"+Поиск+"/%");
	 Запрос.УстановитьПараметр("ПарамПоиск2",Поиск1);
	 Запрос.УстановитьПараметр("ПарамПоиск3","%/"+Поиск1+"/%");
	 РезультатЗапроса = Запрос.Выполнить();
	 Если РезультатЗапроса.Пустой() Тогда
		 
	 Иначе
		ЭтоСкания = Истина; 
		 Выборка = РезультатЗапроса.Выбрать();
		 Пока Выборка.Следующий() Цикл
			 Номера.Добавить(Выборка.НомерСкания);
			 НомераВр = РазбитьСтрокуНаМассивПодстрок(Выборка.НомерЗамена,"/");
			 Номер1 = НомераВр.Количество();
		 	 Номер2 = 0;
			 Пока Номер2<Номер1 Цикл
				 Если СтрДлина(НомераВр[Номер2]) > 3 Тогда
					  Номера.Добавить(НомераВр[Номер2]);
				 КонецЕсли;
				 Номер2 = Номер2 + 1;
			 КонецЦикла;
			 
		 КонецЦикла;
	 КонецЕсли;
	 
	 Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	НомераЗамен.Ссылка,
	 |	НомераЗамен.ВерсияДанных,
	 |	НомераЗамен.ПометкаУдаления,
	 |	НомераЗамен.Предопределенный,
	 |	НомераЗамен.Код,
	 |	НомераЗамен.Наименование,
	 |	НомераЗамен.СканияКод,
	 |	НомераЗамен.НомерСкания,
	 |	НомераЗамен.НомерПоиск,
	 |	НомераЗамен.НомерПолный,
	 |	НомераЗамен.Бренд,
	 |	НомераЗамен.Представление
	 |ИЗ
	 |	Справочник.НомераЗамен КАК НомераЗамен
	 |ГДЕ
	 |	НомераЗамен.НомерСкания ПОДОБНО &ПарамПоиск
	 |	ИЛИ НомераЗамен.НомерПолный ПОДОБНО &ПарамПоиск
	 |	ИЛИ НомераЗамен.НомерСкания ПОДОБНО &ПарамПоиск1
	 |	ИЛИ НомераЗамен.НомерПоиск ПОДОБНО &ПарамПоиск1";
	 Запрос.УстановитьПараметр("ПарамПоиск",Поиск);
	 Запрос.УстановитьПараметр("ПарамПоиск1",Поиск1);
	 РезультатЗапроса = Запрос.Выполнить();
	 Если РезультатЗапроса.Пустой() Тогда
		 
	 Иначе
		 ЭтоЗамена = Истина; 
		 Выборка = РезультатЗапроса.Выбрать();
		 Пока Выборка.Следующий() Цикл
			 Номера.Добавить(Выборка.НомерСкания);
		 КонецЦикла;
	 КонецЕсли;
	 
	 Если ЭтоЗамена ИЛИ ЭтоСкания Тогда
		
		 ПоискПо = "";
		 Номер1 = Номера.Количество();
		 Номер2 = 0;
		 Пока Номер2 < Номер1 Цикл
			ПоискПо = ПоискПо + " ИЛИ НомераЗамен.НомерСкания = """+Номера[Номер2]+"""";
			Номер2 = Номер2 +1;
		 КонецЦикла;
		
		 Запрос.Текст = 
		 "ВЫБРАТЬ DISTINCT
		 |	НомераЗамен.НомерСкания как НомерСкания,
		 |	НомераЗамен.НомерПолный,
		 |	НомераЗамен.НомерПоиск как НомерПоиск
		 |ИЗ
		 |	Справочник.НомераЗамен КАК НомераЗамен
		 |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НомераСкания КАК НомераСкания
		 |		ПО НомераЗамен.НомерСкания = НомераСкания.Код
		 |ГДЕ
		 |	НомераЗамен.НомерСкания ПОДОБНО &ПарамПоиск
		 |			ИЛИ НомераЗамен.НомерПоиск ПОДОБНО &ПарамПоиск1 "+ПоискПо;
		 Запрос.УстановитьПараметр("ПарамПоиск",Поиск);
		 Запрос.УстановитьПараметр("ПарамПоиск1",Поиск1);
		 РезультатЗапроса = Запрос.Выполнить();
		 Если РезультатЗапроса.Пустой() Тогда
		 
		 Иначе 
			 Выборка = РезультатЗапроса.Выбрать();
			 Пока Выборка.Следующий() Цикл
				 Номера.Добавить(Выборка.НомерСкания);
				 Номера.Добавить(Выборка.НомерПоиск);
			 КонецЦикла;
		 КонецЕсли;
		 
		 Если ЭтоСкания Тогда
			 Запрос.Текст=
			 "ВЫБРАТЬ
			 |	НомераСкания.Ссылка,
			 |	НомераСкания.Код КАК Код,
			 |	НомераСкания.Наименование,
			 |	НомераСкания.НомерСкания КАК НомерСкания,
			 |	НомераСкания.НомерЗамена КАК НомерЗамена,
			 |	НомераСкания.Представление
			 |ИЗ
			 |	Справочник.НомераСкания КАК НомераСкания
			 |ГДЕ
			 |	НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск 
			 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск1
			 |	ИЛИ НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск1 
			 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск2
			 |УПОРЯДОЧИТЬ ПО Код";
			 Запрос.УстановитьПараметр("ПарамПоиск",Поиск);
			 Запрос.УстановитьПараметр("ПарамПоиск1","%/"+Поиск+"/%");
			 Запрос.УстановитьПараметр("ПарамПоиск2",Поиск1);
			 Запрос.УстановитьПараметр("ПарамПоиск3","%/"+Поиск1+"/%");
		 Иначе
			 ПоискПо = "";
			 Номер1 = Номера.Количество();
			 Номер2 = 0;
			 Пока Номер2 < Номер1 Цикл
				ПоискПо = ПоискПо + " ИЛИ НомераСкания.НомерСкания = """+Номера[Номер2]+""" ИЛИ НомераСкания.НомерЗамена ПОДОБНО ""%/"+Номера[Номер2]+"/%""";
				Номер2 = Номер2 +1;
			 КонецЦикла;

			 Если ЭтоЗамена Тогда
				 Запрос.Текст = 
				 "ВЫБРАТЬ
				 |	НомераСкания.Ссылка,
				 |	НомераСкания.Код КАК Код,
				 |	НомераСкания.Наименование,
				 |	НомераСкания.НомерСкания КАК НомерСкания,
				 |	НомераСкания.НомерЗамена КАК НомерЗамена,
				 |	НомераСкания.Представление
				 |ИЗ
				 |	Справочник.НомераСкания КАК НомераСкания
				 |ГДЕ
				 |	НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск 
				 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск1
				 |	ИЛИ НомераСкания.НомерСкания ПОДОБНО &ПарамПоиск2 
				 |	ИЛИ НомераСкания.НомерЗамена ПОДОБНО &ПарамПоиск3" + ПоискПо;
				 Запрос.УстановитьПараметр("ПарамПоиск",Поиск);
				 Запрос.УстановитьПараметр("ПарамПоиск1","%/"+Поиск+"/%");
				 Запрос.УстановитьПараметр("ПарамПоиск2",Поиск1);
				 Запрос.УстановитьПараметр("ПарамПоиск3","%/"+Поиск1+"/%");
			 КонецЕсли;
		 КонецЕсли;
		 РезультатЗапроса = Запрос.Выполнить();
		 Если РезультатЗапроса.Пустой() Тогда
		 
		 Иначе 
			 Выборка = РезультатЗапроса.Выбрать();
			 Пока Выборка.Следующий() Цикл
				 Номера.Добавить(Выборка.НомерСкания);
			 КонецЦикла;
		 КонецЕсли;
	 КонецЕсли;
	 
     ВОЗВРАТ Номера; 	 
КонецФункции


&НаСервере
Функция РазбитьСтрокуНаМассивПодстрок(ИсходнаяСтрока,РазделительСтрок)
   СтрокаДляРазбора = ИсходнаяСтрока;
   СтрокаДляРазбора = СтрЗаменить(СтрокаДляРазбора, РазделительСтрок, Символы.ПС);
   МассивСтрок = новый Массив;
   КолвоСтрок = СтрЧислоСтрок(СтрокаДляРазбора);
   Для НомСтр = 1 По КолвоСтрок Цикл
      МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаДляРазбора, НомСтр));
  КонецЦикла;
   Возврат МассивСтрок;
КонецФункции

&НаСервере
Функция УдалитьПовторяющиесяЭлементыМассива(Массив) 
 ТекущийИндекс = 0; 
	ВсегоЭлементов = Массив.Количество(); 
	Пока ТекущийИндекс < ВсегоЭлементов Цикл 
		Индекс2 = ТекущийИндекс + 1; 
		Пока Индекс2 < ВсегоЭлементов Цикл 
			Если Массив[Индекс2] = Массив[ТекущийИндекс] Тогда 
				Массив.Удалить(Индекс2); 
				ВсегоЭлементов = ВсегоЭлементов - 1; 
			Иначе 
				Индекс2 = Индекс2 + 1; 
			КонецЕсли; 
		КонецЦикла; 
		ТекущийИндекс = ТекущийИндекс + 1; 
	КонецЦикла; 
Возврат Массив; 
КонецФункции    

&НаКлиенте
Процедура очистить(Команда)
	// Вставить содержимое обработчика.
	ОчиститьПоиск();
КонецПроцедуры

&НаСервере
Процедура ОчиститьПоиск()
		Текст1 = 
	"	ВЫБРАТЬ
	| СправочникНоменклатура.Ссылка,
	| СправочникНоменклатура.ВерсияДанных,
	| СправочникНоменклатура.ПометкаУдаления,
	| СправочникНоменклатура.Предопределенный,
	| СправочникНоменклатура.Код,
	| СправочникНоменклатура.Наименование,
	| СправочникНоменклатура.Артикул,
	| СправочникНоменклатура.НомерПроизводителя,
	| СправочникНоменклатура.МестоНаСкладе,
	| СправочникНоменклатура.Бренд,
	| СправочникНоменклатура.АртикулПоиск,
	| СправочникНоменклатура.НомерПоиск,
	| СправочникНоменклатура.НаименованиеПолное,
	| РегистрНакопления1Остатки.КолвоОстаток,
	| СправочникНоменклатура.Комплектность.(
	| 	Ссылка,
	| 	НомерСтроки,
	| 	Артикул,
	| 	Наименование,
	| 	Количество,
	| 	Комментарий,
	| 	НомерПоиск
	| ),
	| СправочникНоменклатура.РекомендованаяЦена
| ИЗ
	| Справочник.Номенклатура КАК СправочникНоменклатура
	| 	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	| 	ПО СправочникНоменклатура.Ссылка = РегистрНакопления1Остатки.Товар ";
	
	Список.ТекстЗапроса= Текст1;
	
КонецПроцедуры


