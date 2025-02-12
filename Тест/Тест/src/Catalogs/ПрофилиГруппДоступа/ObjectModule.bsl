#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыеРолиПрофиля; // Роли профиля до изменения для использования
                         // в обработчике события ПриЗаписи.

Перем СтараяПометкаУдаления; // Пометка удаления профиля групп доступа до изменения
                             // для использования в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();
	РегистрыСведений.ПраваРолей.ПроверитьДанныеРегистра();
	
	// Получение старых ролей профиля.
	РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Роли");
	Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
		СтарыеРолиПрофиля = РезультатЗапроса.Выгрузить();
	Иначе
		СтарыеРолиПрофиля = Роли.Выгрузить(Новый Массив);
	КонецЕсли;
	
	СтараяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Ссылка, "ПометкаУдаления");
	
	Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		Пользователь = Неопределено;
	Иначе
		// Проверка ролей.
		НомерСтроки = Роли.Количество() - 1;
		РолиАдминистратора = Новый Массив;
		РолиАдминистратора.Добавить("Роль.ПолныеПрава");
		РолиАдминистратора.Добавить("Роль.АдминистраторСистемы");
		ИдентификаторыРолей = ОбщегоНазначения.ИдентификаторыОбъектовМетаданных(РолиАдминистратора);
		Пока НомерСтроки >= 0 Цикл
			Если ВРег(Роли[НомерСтроки].Роль) = ВРег(ИдентификаторыРолей["Роль.ПолныеПрава"])
			 ИЛИ ВРег(Роли[НомерСтроки].Роль) = ВРег(ИдентификаторыРолей["Роль.АдминистраторСистемы"]) Тогда
				
				Роли.Удалить(НомерСтроки);
			КонецЕсли;
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРеквизитПоставляемыйПрофильИзменен") Тогда
		ПоставляемыйПрофильИзменен =
			Справочники.ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен(ЭтотОбъект);
	КонецЕсли;
	
	ИнтерфейсУпрощенный = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если ИнтерфейсУпрощенный Тогда
		// Обновление наименования у персональных групп доступа этого профиля (если есть).
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Профиль",      Ссылка);
		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	ГруппыДоступа.Профиль = &Профиль
		|	И ГруппыДоступа.Пользователь <> НЕОПРЕДЕЛЕНО
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Наименование <> &Наименование";
		ИзмененныеГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Если ИзмененныеГруппыДоступа.Количество() > 0 Тогда
			Для каждого ГруппаДоступаСсылка Из ИзмененныеГруппыДоступа Цикл
				ПерсональнаяГруппаДоступаОбъект = ГруппаДоступаСсылка.ПолучитьОбъект();
				ПерсональнаяГруппаДоступаОбъект.Наименование = Наименование;
				ПерсональнаяГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
				ПерсональнаяГруппаДоступаОбъект.Записать();
			КонецЦикла;
			ДополнительныеСвойства.Вставить(
				"ПерсональныеГруппыДоступаСОбновленнымНаименованием", ИзмененныеГруппыДоступа);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьОднозначностьПоставляемыхДанных();
	
	ОбъектыМетаданных = ОбновитьРолиПользователейПриИзмененииРолейПрофиля();
	
	// При установке пометки удаления нужно установить пометку удаления у групп доступа профиля.
	Если ПометкаУдаления И СтараяПометкаУдаления = Ложь Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Профиль", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	(НЕ ГруппыДоступа.ПометкаУдаления)
		|	И ГруппыДоступа.Профиль = &Профиль";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ГруппаДоступаОбъект.ПометкаУдаления = Истина;
			ГруппаДоступаОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьГруппыДоступаПрофиля") Тогда
		Справочники.ГруппыДоступа.ОбновитьГруппыДоступаПрофиля(Ссылка, Истина);
	КонецЕсли;
	
	// Обновление таблиц и значений групп доступа.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профиль", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль = &Профиль
	|	И (НЕ ГруппыДоступа.ЭтоГруппа)";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ГруппыДоступаПрофиля = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(ГруппыДоступаПрофиля);
		
		Если ОбъектыМетаданных.Количество() > 0 Тогда
			РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(
				ГруппыДоступаПрофиля, ОбъектыМетаданных);
		КонецЕсли;
	КонецЕсли;
	
	Справочники.ПрофилиГруппДоступа.ОбновитьТаблицыГруппДоступаПрофилейСИзмененнымСоставомРолейПриЗагрузке();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
	ПроверитьОднозначностьПоставляемыхДанных(Истина, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбъектКопирования.Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		Роли.Очистить();
	КонецЕсли;
	
	ИдентификаторПоставляемыхДанных = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Функция ОбновитьРолиПользователейПриИзмененииРолейПрофиля()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профиль", Ссылка);
	Запрос.УстановитьПараметр("СтарыеРолиПрофиля", СтарыеРолиПрофиля);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтарыеРолиПрофиля.Роль
	|ПОМЕСТИТЬ СтарыеРолиПрофиля
	|ИЗ
	|	&СтарыеРолиПрофиля КАК СтарыеРолиПрофиля
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Роль
	|ПОМЕСТИТЬ ИзмененныеРоли
	|ИЗ
	|	(ВЫБРАТЬ
	|		СтарыеРолиПрофиля.Роль КАК Роль,
	|		-1 КАК ВидИзмененияСтроки
	|	ИЗ
	|		СтарыеРолиПрофиля КАК СтарыеРолиПрофиля
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НовыеРолиПрофиля.Роль,
	|		1
	|	ИЗ
	|		Справочник.ПрофилиГруппДоступа.Роли КАК НовыеРолиПрофиля
	|	ГДЕ
	|		НовыеРолиПрофиля.Ссылка = &Профиль) КАК Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	Данные.Роль
	|
	|ИМЕЮЩИЕ
	|	СУММА(Данные.ВидИзмененияСтроки) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Данные.Роль";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.Добавление КАК Добавление,
	|	ПраваРолейРасширений.Изменение КАК Изменение,
	|	ПраваРолейРасширений.ЧтениеБезОграничения КАК ЧтениеБезОграничения,
	|	ПраваРолейРасширений.ДобавлениеБезОграничения КАК ДобавлениеБезОграничения,
	|	ПраваРолейРасширений.ИзменениеБезОграничения КАК ИзменениеБезОграничения,
	|	ПраваРолейРасширений.Просмотр КАК Просмотр,
	|	ПраваРолейРасширений.ИнтерактивноеДобавление КАК ИнтерактивноеДобавление,
	|	ПраваРолейРасширений.Редактирование КАК Редактирование,
	|	ПраваРолейРасширений.ВидИзмененияСтроки КАК ВидИзмененияСтроки
	|ПОМЕСТИТЬ ПраваРолейРасширений
	|ИЗ
	|	&ПраваРолейРасширений КАК ПраваРолейРасширений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПраваРолейРасширений.ОбъектМетаданных КАК ОбъектМетаданных,
	|	ПраваРолейРасширений.Роль КАК Роль,
	|	ПраваРолейРасширений.Добавление КАК Добавление,
	|	ПраваРолейРасширений.Изменение КАК Изменение,
	|	ПраваРолейРасширений.ЧтениеБезОграничения КАК ЧтениеБезОграничения,
	|	ПраваРолейРасширений.ДобавлениеБезОграничения КАК ДобавлениеБезОграничения,
	|	ПраваРолейРасширений.ИзменениеБезОграничения КАК ИзменениеБезОграничения,
	|	ПраваРолейРасширений.Просмотр КАК Просмотр,
	|	ПраваРолейРасширений.ИнтерактивноеДобавление КАК ИнтерактивноеДобавление,
	|	ПраваРолейРасширений.Редактирование КАК Редактирование
	|ПОМЕСТИТЬ ПраваРолей
	|ИЗ
	|	ПраваРолейРасширений КАК ПраваРолейРасширений
	|ГДЕ
	|	ПраваРолейРасширений.ВидИзмененияСтроки = 1
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПраваРолей.ОбъектМетаданных,
	|	ПраваРолей.Роль,
	|	ПраваРолей.Добавление,
	|	ПраваРолей.Изменение,
	|	ПраваРолей.ЧтениеБезОграничения,
	|	ПраваРолей.ДобавлениеБезОграничения,
	|	ПраваРолей.ИзменениеБезОграничения,
	|	ПраваРолей.Просмотр,
	|	ПраваРолей.ИнтерактивноеДобавление,
	|	ПраваРолей.Редактирование
	|ИЗ
	|	РегистрСведений.ПраваРолей КАК ПраваРолей
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПраваРолейРасширений КАК ПраваРолейРасширений
	|		ПО ПраваРолей.ОбъектМетаданных = ПраваРолейРасширений.ОбъектМетаданных
	|			И ПраваРолей.Роль = ПраваРолейРасширений.Роль
	|ГДЕ
	|	ПраваРолейРасширений.ОбъектМетаданных ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваРолей.ОбъектМетаданных
	|ИЗ
	|	ПраваРолей КАК ПраваРолей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИзмененныеРоли КАК ИзмененныеРоли
	|		ПО ПраваРолей.Роль = ИзмененныеРоли.Роль";
	
	Запрос.Текст = Запрос.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|" + ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ПраваРолейРасширений", УправлениеДоступомСлужебный.ПраваРолейРасширений());
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей")
	   И НЕ РезультатыЗапросов[1].Пустой() Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставыГруппПользователей.Пользователь
		|ИЗ
		|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь
		|			И (ГруппыДоступаПользователи.Ссылка.Профиль = &Профиль)";
		
		ПользователиДляОбновленияРолей =
			Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
		
		УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновленияРолей);
	КонецЕсли;
	
	Возврат РезультатыЗапросов[4].Выгрузить().ВыгрузитьКолонку("ОбъектМетаданных");
	
КонецФункции

Процедура ПроверитьОднозначностьПоставляемыхДанных(ПроверкаЗаполнения = Ложь, Отказ = Ложь)
	
	// Проверка однозначности поставляемых данных.
	Если ИдентификаторПоставляемыхДанных <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИдентификаторПоставляемыхДанных", ИдентификаторПоставляемыхДанных);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПрофилиГруппДоступа.Ссылка КАК Ссылка,
		|	ПрофилиГруппДоступа.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
		|ГДЕ
		|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ИдентификаторПоставляемыхДанных";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 1 Тогда
			
			КраткоеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи профиля ""%1"".
				           |Поставляемый профиль уже существует:'"),
				Наименование);
			
			ПодробноеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи профиля ""%1"".
				           |Идентификатор поставляемых данных ""%2"" уже используется в профиле:'"),
				Наименование,
				Строка(ИдентификаторПоставляемыхДанных));
			
			Пока Выборка.Следующий() Цикл
				Если Выборка.Ссылка <> Ссылка Тогда
					
					КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """.";
					
					ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """ ("
						+ Строка(Выборка.Ссылка.УникальныйИдентификатор())+ ")."
				КонецЕсли;
			КонецЦикла;
			
			Если ПроверкаЗаполнения Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки,,,, Отказ);
			Иначе
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Управление доступом.Нарушение однозначности поставляемого профиля'",
					     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
