
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Год = Год(ТекущаяДата());
	Месяц = Месяц(ТекущаяДата());
	ОбновлениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДанных()
	ОбновитьИнфо();
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнфо()
	Дат1 = Дата(Год,Месяц,1);
	Дат2 = КонецМесяца(Дат1);
	
	запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ПродажаЗапчастей.ИтогоРекв) КАК Поле1
	               |ИЗ
	               |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	               |ГДЕ
	               |	ПродажаЗапчастей.Оплачено = ИСТИНА
	               |	И ПродажаЗапчастей.Новые = ЛОЖЬ
	               |	И ПродажаЗапчастей.Дата >= &Дат1
	               |	И ПродажаЗапчастей.Дата <= &Дат2";
	Запрос.УстановитьПараметр("Дат1",Дат1);
	Запрос.УстановитьПараметр("Дат2",Дат2);
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ПродажыБУ = Таблица.Итог("Поле1");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ПродажаЗапчастей.ИтогоРекв) КАК Поле1
	               |ИЗ
	               |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	               |ГДЕ
	               |	ПродажаЗапчастей.Оплачено = ИСТИНА
	               |	И ПродажаЗапчастей.Новые = ИСТИНА
	               |	И ПродажаЗапчастей.Дата >= &Дат1
	               |	И ПродажаЗапчастей.Дата <= &Дат2";
	Запрос.УстановитьПараметр("Дат1",Дат1);
	Запрос.УстановитьПараметр("Дат2",Дат2);
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ПродажиНовые = Таблица.Итог("Поле1");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ОтданоСМашиныОстатки.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.ОтданоСМашины КАК ОтданоСМашиныОстатки
	               |ГДЕ
	               |	ОтданоСМашиныОстатки.Кто = 1
	               |	И ОтданоСМашиныОстатки.Период >= &Дат1
	               |	И ОтданоСМашиныОстатки.Период <= &Дат2
	               |	И ОтданоСМашиныОстатки.ВидДвижения = &ВидДвижения";
	Запрос.УстановитьПараметр("Дат1",Дат1);
	Запрос.УстановитьПараметр("Дат2",Дат2);
	Запрос.УстановитьПараметр("ВидДвижения",ВидДвиженияНакопления.Приход);
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ВыведеноМарату = Таблица.Итог("СуммаОстаток");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ОтданоСМашиныОстатки.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.ОтданоСМашины КАК ОтданоСМашиныОстатки
	               |ГДЕ
	               |	ОтданоСМашиныОстатки.Кто = 2
	               |	И ОтданоСМашиныОстатки.Период >= &Дат1
	               |	И ОтданоСМашиныОстатки.Период <= &Дат2
	               |	И ОтданоСМашиныОстатки.ВидДвижения = &ВидДвижения";
	Запрос.УстановитьПараметр("Дат1",Дат1);
	Запрос.УстановитьПараметр("Дат2",Дат2);	
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ВыведеноНам = Таблица.Итог("СуммаОстаток");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ОтданоСМашиныОстатки.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.ОтданоСМашины КАК ОтданоСМашиныОстатки
	               |ГДЕ
	               |	ОтданоСМашиныОстатки.Кто = 3
	               |	И ОтданоСМашиныОстатки.Период >= &Дат1
	               |	И ОтданоСМашиныОстатки.Период <= &Дат2
	               |	И ОтданоСМашиныОстатки.ВидДвижения = &ВидДвижения";
	Запрос.УстановитьПараметр("Дат1",Дат1);
	Запрос.УстановитьПараметр("Дат2",Дат2);			   
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ВыведеноАртему = Таблица.Итог("СуммаОстаток");
	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(РасходыОстатки.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	РегистрНакопления.Расходы КАК РасходыОстатки
	               |ГДЕ
	               |	РасходыОстатки.ВидРасхода = &ВидРасхода
				   |	И РасходыОстатки.Период >= &Дат1
	               |	И РасходыОстатки.Период <= &Дат2
	               |	И РасходыОстатки.ВидДвижения = &ВидДвижения";
	Запрос.УстановитьПараметр("ВидРасхода",Справочники.ВидыРасходов.НайтиПоНаименованию("Расходы на доставку"));
	//Запрос.УстановитьПараметр("ВидРасхода",Справочники.ВидыРасходов.НайтиПоКоду("000000003"));

	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	РасхДост = Таблица.Итог("СуммаОстаток");
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СУММА(Расходы.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	Документ.Расходы КАК Расходы
	               |ГДЕ
	               |	Расходы.Проведен = ИСТИНА
	               |	И Расходы.Новые = ЛОЖЬ
				   |    И Расходы.Зарплата = ИСТИНА
	               |	И Расходы.Дата >= &Дат1
	               |	И Расходы.Дата <= &Дат2";
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
    РасходыЗарплата = Таблица.Итог("СуммаОстаток");


	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СУММА(Расходы.Сумма) КАК СуммаОстаток
	               |ИЗ
	               |	Документ.Расходы КАК Расходы
	               |ГДЕ
	               |	Расходы.Проведен = ИСТИНА
	               |	И Расходы.Новые = ЛОЖЬ
	               |	И Расходы.Дата >= &Дат1
	               |	И Расходы.Дата <= &Дат2";
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
	ВсеРасходы = Таблица.Итог("СуммаОстаток")-РасхДост;
    Расходы = ВсеРасходы-РасходыЗарплата;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СУММА(ВложенияВолжска.Сумма) КАК Сумма
	               |ИЗ
	               |	Справочник.ВложенияВолжска КАК ВложенияВолжска
	               |ГДЕ
	               |	ВложенияВолжска.Дата >= &Дат1
	               |	И ВложенияВолжска.Дата <= &Дат2";
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
    РасходыВолжска = Таблица.Итог("Сумма");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(Машины.Сумма) КАК Сумма
	               |ИЗ
	               |	Справочник.Машины КАК Машины
	               |ГДЕ
	               |	Машины.Дата >= &Дат1
	               |	И Машины.Дата <= &Дат2";
				   
	Реультат = Запрос.Выполнить();
    Таблица = Реультат.Выгрузить();
    ПокупкаМашин = Таблица.Итог("Сумма");
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ОбновлениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	Месяц=1;
	ОбновлениеДанных();
КонецПроцедуры


