#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация.
// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенная конфигурация.
//
Функция ЭтоРазделеннаяКонфигурация() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЕстьРазделители = МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация();
	Иначе
		ЕстьРазделители = Ложь;
	КонецЕсли;
	
	Возврат ЕстьРазделители;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.РазделителиКонфигурации.
// Возвращает массив существующих в конфигурации разделителей.
//
// Возвращаемое значение:
//   ФиксированныйМассив - массив имен общих реквизитов, которые
//     являются разделителями.
//
Функция РазделителиКонфигурации() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Разделители = МодульРаботаВМоделиСервиса.РазделителиКонфигурации();
	Иначе
		Разделители = Новый  Массив;
	КонецЕсли;
	
	Возврат Разделители;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.СоставОбщегоРеквизита.
// Возвращает состав общего реквизита с заданным именем.
//
// Параметры:
//   Имя - Строка - Имя общего реквизита.
//
// Возвращаемое значение:
//   СоставОбщегоРеквизита - список объектов метаданных, в которые входит общий реквизит.
//
Функция СоставОбщегоРеквизита(Знач Имя) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СоставОбщегоРеквизита = МодульРаботаВМоделиСервиса.СоставОбщегоРеквизита(Имя);
	Иначе
		СоставОбщегоРеквизита = Неопределено;
	КонецЕсли;
	
	Возврат СоставОбщегоРеквизита;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных.
// Возвращает признак того, что объект метаданных используется в общих реквизитах-разделителях.
//
// Параметры:
//   ИмяОбъектаМетаданных - Строка - имя объекта,
//   Разделитель - Строка - имя общего реквизита-разделителя, на разделение которыми проверяется объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенный объект.
//
Функция ЭтоРазделенныйОбъектМетаданных(Знач ИмяОбъектаМетаданных, Знач Разделитель) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЭтоРазделенныйОбъектМетаданных = МодульРаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяОбъектаМетаданных);
	Иначе
		ЭтоРазделенныйОбъектМетаданных = Ложь;
	КонецЕсли;
	
	Возврат ЭтоРазделенныйОбъектМетаданных;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.РазделительОсновныхДанных.
// Возвращает имя общего реквизита, который является разделителем основных данных.
//
// Возвращаемое значение:
//   Строка - имя общего реквизита.
//
Функция РазделительОсновныхДанных() Экспорт
	
	Результат = "";
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Результат = МодульРаботаВМоделиСервиса.РазделительОсновныхДанных();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.РазделительВспомогательныхДанных.
// Возвращает имя общего реквизита, который является разделителем вспомогательных данных.
//
// Возвращаемое значение:
//   Строка - имя общего реквизита.
//
Функция РазделительВспомогательныхДанных() Экспорт
	
	Результат = "";
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Результат = МодульРаботаВМоделиСервиса.РазделительВспомогательныхДанных();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Устарела. Необходимо использовать ОбщегоНазначения.РазделениеВключено.
// Возвращает признак работы в режиме разделения данных по областям
// (технически это признак условного разделения).
// 
// Возвращает Ложь, если конфигурация не может работать в режиме разделения данных
// (не содержит общих реквизитов, предназначенных для разделения данных).
//
// Возвращаемое значение:
//  Булево - Истина, если разделение включено.
//         - Ложь,   если разделение выключено или не поддерживается.
//
Функция РазделениеВключено() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		РазделениеВключено = МодульРаботаВМоделиСервиса.РазделениеВключено();
	Иначе
		РазделениеВключено = Ложь;
	КонецЕсли;
	
	Возврат РазделениеВключено;
	
КонецФункции

// Устарела. Необходимо использовать ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных.
// Возвращает признак возможности обращения к разделенным данным (которые входят в состав разделителей).
// Признак относится к сеансу, но может меняться во время работы сеанса, если разделение было включено
// в самом сеансе, поэтому проверку следует делать непосредственно перед обращением к разделенным данным.
// 
// Возвращает Истина, если конфигурация не может работать в режиме разделения данных
// (не содержит общих реквизитов, предназначенных для разделения данных).
//
// Возвращаемое значение:
//   Булево - Истина, если разделение не поддерживается, либо разделение выключено,
//                    либо разделение включено и разделители    установлены.
//          - Ложь,   если разделение включено и разделители не установлены.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ДоступноИспользованиеРазделенныхДанных = МодульРаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных();
	Иначе
		ДоступноИспользованиеРазделенныхДанных = Истина;
	КонецЕсли;
	
	Возврат ДоступноИспользованиеРазделенныхДанных;
	
КонецФункции

// Устарела. Возвращает объект ПреобразованиеXSL созданный из общего макета с переданным
// именем.
//
// Параметры:
//   ИмяОбщегоМакета - Строка - имя общего макета типа ДвоичныеДанные содержащего
//     файл преобразования XSL.
//
// Возвращаемое значение:
//   ПреобразованиеXSL - объект ПреобразованиеXSL.
//
Функция ПолучитьПреобразованиеXSLИзОбщегоМакета(Знач ИмяОбщегоМакета) Экспорт
	
	ДанныеМакета = ПолучитьОбщийМакет(ИмяОбщегоМакета);
	ИмяФайлаПреобразования = ПолучитьИмяВременногоФайла("xsl");
	ДанныеМакета.Записать(ИмяФайлаПреобразования);
	
	Преобразование = Новый ПреобразованиеXSL;
	Преобразование.ЗагрузитьТаблицуСтилейXSLИзФайла(ИмяФайлаПреобразования);
	
	Попытка
		УдалитьФайлы(ИмяФайлаПреобразования);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение XSL'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Преобразование;
	
КонецФункции

// Устарела. Необходимо использовать РаботаВМоделиСервиса.СеансЗапущенБезРазделителей.
// Определяет, сеанс запущен с разделителями или без.
//
// Возвращаемое значение:
//   Булево - Истина, если сеанс запущен без разделителей.
//
Функция СеансЗапущенБезРазделителей() Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Возврат СеансЗапущенБезРазделителей;
	
КонецФункции

// Устарела. Для получения нужных свойств следует использовать следующие функции:
//  свойство ЭтоАдминистраторСистемы   - Пользователи.ЭтоПолноправныйПользователь(, Истина);
//  свойство ЭтоАдминистраторПрограммы - Пользователи.ЭтоПолноправныйПользователь();
//  свойство МодельСервиса             - ОбщегоНазначение.РазделениеВключено();
//  свойство Автономный                - ОбщегоНазначение.ЭтоАвтономноеРабочееМесто();
//  свойство Локальный                 - Не Автономный И Не МодельСервиса;
//  свойство Файловый                  - ОбщегоНазначения.ИнформационнаяБазаФайловая();
//  свойство КлиентСерверный           - Не ОбщегоНазначения.ИнформационнаяБазаФайловая();
//  свойство ЛокальныйФайловый         - Локальный И Файловый (см. выше);
//  свойство ЛокальныйКлиентСерверный  - Локальный И КлиентСерверный (см. выше);
//  свойство ЭтоWindowsКлиент          - ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент();
//  свойство ЭтоLinuxКлиент            - ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
//  свойство ЭтоOSXКлиент              - ОбщегоНазначенияКлиентСервер.ЭтоOSXКлиент();
//  свойство ЭтоВебКлиент              - ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент().
// 
// Определяет текущий режим работы программы.
// Используется в панелях настроек программы для скрытия элементов, не предназначенных сразу для всех режимов работы.
//
//   В панелях настроек программы включены 5 интерфейсов:
//     - Для администратора сервиса в области данных абонента (АС).
//     - Для администратора абонента (АА).
//     - Для администратора локального решения в клиент-серверном режиме (ЛКС).
//     - Для администратора локального решения в файловом режиме (ЛФ).
//     - Для администратора автономного рабочего места (АРМ).
//   
//   Интерфейсы АС и АА разрезаются при помощи скрытия групп и элементов формы
//     для всех ролей, кроме роли "АдминистраторСистемы".
//   
//   Администратор сервиса, выполнивший вход в область данных,
//     должен видеть те же настройки что и администратор абонента
//     вместе с настройками сервиса (неразделенными).
//
// Возвращаемое значение:
//   Структура - Настройки, описывающие права текущего пользователя и текущий режим работы программы.
//     По правам:
//       * ЭтоАдминистраторСистемы   - Булево - Истина, если есть право администрирования информационной базы.
//       * ЭтоАдминистраторПрограммы - Булево - Истина, если есть доступ ко всем "прикладным" данным информационной
//                                              базы.
//     По режимам работы базы:
//       * МодельСервиса   - Булево - Истина, если в конфигурации есть разделители и они условно включены.
//       * Локальный       - Булево - Истина, если конфигурации работает в обычном режиме (не в модели сервиса и не в
//                                    автономном рабочем месте).
//       * Автономный      - Булево - Истина, если конфигурации работает в режиме АРМ (автономное рабочее место).
//       * Файловый        - Булево - Истина, если конфигурации работает в файловом режиме.
//       * КлиентСерверный - Булево - Истина, если конфигурации работает в клиент-серверном режиме.
//       * ЛокальныйФайловый        - Булево - Истина, если работа в обычном файловом режиме.
//       * ЛокальныйКлиентСерверный - Булево - Истина, если работа в обычном клиент-серверном режиме.
//     По функциональности клиентской части:
//       * ЭтоLinuxКлиент - Булево - Истина, если клиентское приложение запущено под управлением ОС Linux.
//       * ЭтоВебКлиент   - Булево - Истина, если клиентское приложение является Веб-клиентом.
//
Функция РежимРаботыПрограммы() Экспорт
	РежимРаботы = Новый Структура;
	
	// Права текущего пользователя.
	РежимРаботы.Вставить("ЭтоАдминистраторПрограммы", Пользователи.ЭтоПолноправныйПользователь(, Ложь, Ложь)); // АА, АС, ЛКС, ЛФ
	РежимРаботы.Вставить("ЭтоАдминистраторСистемы",   Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь)); // АС, ЛКС, ЛФ
	
	// Режимы работы сервера.
	РежимРаботы.Вставить("МодельСервиса", РазделениеВключено()); // АС, АА
	РежимРаботы.Вставить("Локальный",     ПолучитьФункциональнуюОпцию("РаботаВЛокальномРежиме")); // ЛКС, ЛФ
	РежимРаботы.Вставить("Автономный",    ПолучитьФункциональнуюОпцию("РаботаВАвтономномРежиме")); // АРМ
	РежимРаботы.Вставить("Файловый",        Ложь); // АС, АА, ЛФ
	РежимРаботы.Вставить("КлиентСерверный", Ложь); // АС, АА, ЛКС
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		РежимРаботы.Файловый = Истина;
	Иначе
		РежимРаботы.КлиентСерверный = Истина;
	КонецЕсли;
	
	РежимРаботы.Вставить("ЛокальныйФайловый",
		РежимРаботы.Локальный И РежимРаботы.Файловый); // ЛФ
	РежимРаботы.Вставить("ЛокальныйКлиентСерверный",
		РежимРаботы.Локальный И РежимРаботы.КлиентСерверный); // ЛКС
	
	// Режимы работы клиента.
	РежимРаботы.Вставить("ЭтоWindowsКлиент", ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент());
	РежимРаботы.Вставить("ЭтоLinuxКлиент"  , ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент());
	РежимРаботы.Вставить("ЭтоOSXКлиент"    , ОбщегоНазначенияКлиентСервер.ЭтоOSXКлиент());
	РежимРаботы.Вставить("ЭтоВебКлиент"    , ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент());
	
	Возврат РежимРаботы;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устарела. Необходимо использовать РаботаВМоделиСервиса.РазделенныеОбъектыМетаданных.
// Возвращает список полных имен всех объектов метаданных, использующихся в общем реквизите-разделителе,
// имя которого передано в качестве значения параметра Разделитель, и значения свойств объекта метаданных,
// которые могут потребоваться для дальнейшей его обработки в универсальных алгоритмах.
// Для последовательностей и журналов документов определяет разделенность по входящим документам: любому из.
//
// Параметры:
//  Разделитель - Строка, имя общего реквизита.
//
// Возвращаемое значение:
// ФиксированноеСоответствие,
//  Ключ - Строка, полное имя объекта метаданных,
//  Значение - ФиксированнаяСтруктура,
//    Имя - Строка, имя объекта метаданных,
//    Разделитель - Строка, имя разделителя, которым разделен объект метаданных,
//    УсловноеРазделение - Строка, полное имя объекта метаданных, выступающего в качестве условия использования
//      разделения объекта метаданных данным разделителем.
//
Функция РазделенныеОбъектыМетаданных(Знач Разделитель) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Результат = МодульРаботаВМоделиСервиса.РазделенныеОбъектыМетаданных(Разделитель);
	Иначе
		Результат = Новый ФиксированноеСоответствие(Новый Соответствие);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если программа работает в режиме автономного рабочего места.
Функция ЭтоАвтономноеРабочееМесто() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
	
	Возврат МодульОбменДаннымиСервер.ЭтоАвтономноеРабочееМесто();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры, применяемых к элементам командного интерфейса, связанных с параметрическими функциональными опциями.
Функция ОпцииИнтерфейса() Экспорт
	
	ОпцииИнтерфейса = Новый Структура;
	Попытка
		ОбщегоНазначенияПереопределяемый.ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ИмяСобытия = НСтр("ru = 'Настройка интерфейса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'При получении опций интерфейса произошла ошибка:
			   |%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Возврат ОпцииИнтерфейса;
КонецФункции

// Доступность объектов метаданных по функциональным опциям.
Функция ДоступностьОбъектовПоОпциям() Экспорт
	Параметры = ОбщегоНазначенияПовтИсп.ОпцииИнтерфейса();
	Если ТипЗнч(Параметры) = Тип("ФиксированнаяСтруктура") Тогда
		Параметры = Новый Структура(Параметры);
	КонецЕсли;
	
	ДоступностьОбъектов = Новый Соответствие;
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		Значение = -1;
		Для Каждого Элемент Из ФункциональнаяОпция.Состав Цикл
			Если Элемент.Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Значение = -1 Тогда
				Значение = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя, Параметры);
			КонецЕсли;
			ПолноеИмя = Элемент.Объект.ПолноеИмя();
			Если Значение = Истина Тогда
				ДоступностьОбъектов.Вставить(ПолноеИмя, Истина);
			Иначе
				Если ДоступностьОбъектов[ПолноеИмя] = Неопределено Тогда
					ДоступностьОбъектов.Вставить(ПолноеИмя, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат ДоступностьОбъектов;
КонецФункции

#КонецОбласти
