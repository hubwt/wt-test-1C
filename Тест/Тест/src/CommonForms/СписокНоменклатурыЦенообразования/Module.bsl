
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	ПоискНаСервере();
	
КонецПроцедуры
Процедура ПоискНаСервере()
	ТексЗапросаСПоиском = "ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ НоменклатураПоиск
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	(Номенклатура.Наименование ПОДОБНО &наименование
	|	ИЛИ Номенклатура.Артикул ПОДОБНО &наименование
	|	ИЛИ Номенклатура.АртикулПоиск ПОДОБНО &наименование
	|	ИЛИ Номенклатура.НомерПроизводителя ПОДОБНО &наименование
	|	ИЛИ Номенклатура.Код ПОДОБНО &наименование)
	|
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	НоменклатураНомераЗамен.Ссылка
	|ИЗ
	|	Справочник.Номенклатура.НомераЗамен КАК НоменклатураНомераЗамен
	|ГДЕ
	|	НоменклатураНомераЗамен.НомерЗамены ПОДОБНО &наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК Спросили,
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Спрашивают
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПродажаЗапчастейТаблица.Ссылка) КАК Ссылка,
	|	ПродажаЗапчастейТаблица.Товар КАК Товар
	|ПОМЕСТИТЬ ВТ_Продажи
	|ИЗ
	|	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
	|СГРУППИРОВАТЬ ПО
	|	ПродажаЗапчастейТаблица.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(дт_ЦеныНоменклатуры.Период) КАК Период,
	|	дт_ЦеныНоменклатуры.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ МаксПериод
	|ИЗ
	|	РегистрСведений.дт_ЦеныНоменклатуры КАК дт_ЦеныНоменклатуры
	|ГДЕ
	|	дт_ЦеныНоменклатуры.ТипЦен.Код = ""000000004""
	|СГРУППИРОВАТЬ ПО
	|	дт_ЦеныНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	дт_ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(дт_ЦеныНоменклатуры.Цена) КАК Цена
	|ПОМЕСТИТЬ Актуальная
	|ИЗ
	|	РегистрСведений.дт_ЦеныНоменклатуры КАК дт_ЦеныНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксПериод КАК МаксПериод
	|		ПО (дт_ЦеныНоменклатуры.Период = МаксПериод.Период)
	|		И (дт_ЦеныНоменклатуры.Номенклатура = МаксПериод.Номенклатура)
	|СГРУППИРОВАТЬ ПО
	|	дт_ЦеныНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Наименование,
	|	ВЫБОР
	|		КОГДА СправочникНоменклатура.ЦенаФиксирована = ИСТИНА
	|			ТОГДА ""Актуальная""
	|		ИНАЧЕ ""Старая""
	|	КОНЕЦ КАК ТипЦены,
	|	СправочникНоменклатура.Код КАК Код,
	|	СправочникНоменклатура.Артикул КАК Артикул,
	|	СправочникНоменклатура.НомерПроизводителя КАК НомерПроизводителя,
	|	СправочникНоменклатура.Производитель КАК Производитель,
	|	СправочникНоменклатура.Состояние КАК Состояние,
	|	СправочникНоменклатура.Бренд КАК Бренд,
	|	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток,
	|	СправочникНоменклатура.Серия КАК Серия,
	|	ВТ_Продажи.Ссылка КАК КоличествоПродаж,
	|	ОКР(Актуальная.Цена, 0) КАК Цена,
	|	ВТ_Спрашивают.Спросили КАК Спросили
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки(,) КАК РегистрНакопления1Остатки
	|		ПО (СправочникНоменклатура.Ссылка = РегистрНакопления1Остатки.Товар)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Продажи КАК ВТ_Продажи
	|		ПО (СправочникНоменклатура.Ссылка = ВТ_Продажи.Товар)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Актуальная КАК Актуальная
	|		ПО (Актуальная.Номенклатура = СправочникНоменклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Спрашивают КАК ВТ_Спрашивают
	|		ПО (СправочникНоменклатура.Ссылка = ВТ_Спрашивают.Номенклатура.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НоменклатураПоиск КАК НоменклатураПоиск
	|		ПО (НоменклатураПоиск.Ссылка = СправочникНоменклатура.Ссылка)";
	
	СписокНоменклатуры.ТекстЗапроса = ТексЗапросаСПоиском;
	СписокНоменклатуры.Параметры.УстановитьЗначениеПараметра("Наименование", "%" + СтрокаПоиска + "%");
КонецПроцедуры


&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.НаПереоценку Тогда
		ДатаВПрошлом = ДобавитьМесяц(ТекущаяДата(), -4);
		НачалоГода = ДобавитьМесяц(ТекущаяДата(), -12);
		СписокНоменклатурыНаПереоценку.Параметры.УстановитьЗначениеПараметра("ДатаВПрошлом", ДатаВПрошлом);
		СписокНоменклатурыНаПереоценку.Параметры.УстановитьЗначениеПараметра("ДатаНачала", НачалоДня(НачалоГода));
		СписокНоменклатурыНаПереоценку.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ТекущаяДата());
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиКомандФормы



&НаКлиенте
Процедура Создать(Команда)
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента");
КонецПроцедуры
#КонецОбласти


&НаКлиенте
Процедура Обновить(Команда)
	Количество = КоличествоСтрокВСписке("СписокНоменклатурыНаПереоценку");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекст(Команда)

	Перем ТекстСообщения;
	
	Отказ = Ложь;
	
	общЗаданияПоРасп.ОбновитьОдинТовар(ЭтаФорма.Элементы.СписокНоменклатуры.ТекущаяСтрока, ТекстСообщения, Отказ);
	
	Если ТекстСообщения <> Неопределено Тогда
		
		Картинка = ?(Отказ, БиблиотекаКартинок.Остановить, Неопределено);
		Ключ = Строка(ЭтаФорма.УникальныйИдентификатор) + "_" + ЭтаФорма.Элементы.СписокНоменклатуры.ТекущиеДанные.Код; 
		ПоказатьОповещениеПользователя(,, ТекстСообщения, Картинка,, Ключ);
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция КоличествоСтрокВСписке(НазваниеСписка) // Строка 
	// Комлев АА +++
	СКД = Элементы[НазваниеСписка].ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	НастройкиКД = Элементы[НазваниеСписка].ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикКД.Выполнить(СКД, НастройкиКД, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД);
	ПроцессорВыводаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатКД_ТЗ = ПроцессорВыводаКД.Вывести(ПроцессорКД);

	Возврат РезультатКД_ТЗ.Количество();
	// Комлев АА ---
КонецФункции

&НаКлиенте
Процедура СписокНоменклатурыНаПереоценкуПриАктивизацииСтроки(Элемент)
	ОбновитьОтборПартий("СписокНоменклатурыНаПереоценку");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборПартий(Таблица)
	ТекДанные = Элементы[Таблица].ТекущаяСтрока;
	СписокПартий.Параметры.УстановитьЗначениеПараметра("Товар", ТекДанные);

КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокНоменклатуры.ТекущиеДанные <> Неопределено Тогда
		ОбновитьОтборПартий("СписокНоменклатуры");
	КонецЕсли;

КонецПроцедуры



&НаКлиенте
Процедура СписокНомВостДеталейПриАктивизацииСтроки(Элемент)
	Если Элементы.СписокНомВостДеталей.ТекущиеДанные <> Неопределено Тогда
		ОбновитьОтборПартий("СписокНомВостДеталей");
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьДетальНаСайте1(Команда)
	ОбщДействия.ОткрытьДетальНаСайтеWT10(ЭтаФорма.Элементы.СписокПартий.ТекущиеДанные.индкод);
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьКарточкуТовараНаСайте(Команда)

	ОбщДействия.ОткрытьКарточкуТовараНаСайтеWT10(ЭтаФорма.Элементы.СписокНоменклатуры.ТекущиеДанные.Код);
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПартийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтруктураЗаписи = Новый Структура("индкод", ПолучитьиндКод(Элементы.СписокПартий.ТекущиеДанные.индКод));
	МассивСтруктураЗаписи = Новый Массив;
	МассивСтруктураЗаписи.Добавить(СтруктураЗаписи);
	КлючЗаписи = Новый ("РегистрСведенийКлючЗаписи.ИндНомер", МассивСтруктураЗаписи);

	Параметрыформы = Новый Структура("Ключ", КлючЗаписи);                            
		
	ОткрытьФорму("РегистрСведений.ИндНомер.ФормаЗаписи", Параметрыформы);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьиндКод(Код)
	Возврат Справочники.ИндКод.НайтиПоНаименованию(Код);
КонецФункции
