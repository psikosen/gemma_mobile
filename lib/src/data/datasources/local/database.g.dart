// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChatThreadsTable extends ChatThreads
    with TableInfo<$ChatThreadsTable, ChatThread> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _threadIdMeta =
      const VerificationMeta('threadId');
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
      'thread_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageTimestampMeta =
      const VerificationMeta('lastMessageTimestamp');
  @override
  late final GeneratedColumn<int> lastMessageTimestamp = GeneratedColumn<int>(
      'last_message_timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unreadCountMeta =
      const VerificationMeta('unreadCount');
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
      'unread_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [threadId, name, lastMessageTimestamp, unreadCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_threads';
  @override
  VerificationContext validateIntegrity(Insertable<ChatThread> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta));
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('last_message_timestamp')) {
      context.handle(
          _lastMessageTimestampMeta,
          lastMessageTimestamp.isAcceptableOrUnknown(
              data['last_message_timestamp']!, _lastMessageTimestampMeta));
    } else if (isInserting) {
      context.missing(_lastMessageTimestampMeta);
    }
    if (data.containsKey('unread_count')) {
      context.handle(
          _unreadCountMeta,
          unreadCount.isAcceptableOrUnknown(
              data['unread_count']!, _unreadCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {threadId};
  @override
  ChatThread map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatThread(
      threadId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thread_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      lastMessageTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_message_timestamp'])!,
      unreadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_count'])!,
    );
  }

  @override
  $ChatThreadsTable createAlias(String alias) {
    return $ChatThreadsTable(attachedDatabase, alias);
  }
}

class ChatThread extends DataClass implements Insertable<ChatThread> {
  final String threadId;
  final String? name;
  final int lastMessageTimestamp;
  final int unreadCount;
  const ChatThread(
      {required this.threadId,
      this.name,
      required this.lastMessageTimestamp,
      required this.unreadCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['thread_id'] = Variable<String>(threadId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['last_message_timestamp'] = Variable<int>(lastMessageTimestamp);
    map['unread_count'] = Variable<int>(unreadCount);
    return map;
  }

  ChatThreadsCompanion toCompanion(bool nullToAbsent) {
    return ChatThreadsCompanion(
      threadId: Value(threadId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      lastMessageTimestamp: Value(lastMessageTimestamp),
      unreadCount: Value(unreadCount),
    );
  }

  factory ChatThread.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatThread(
      threadId: serializer.fromJson<String>(json['threadId']),
      name: serializer.fromJson<String?>(json['name']),
      lastMessageTimestamp:
          serializer.fromJson<int>(json['lastMessageTimestamp']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'threadId': serializer.toJson<String>(threadId),
      'name': serializer.toJson<String?>(name),
      'lastMessageTimestamp': serializer.toJson<int>(lastMessageTimestamp),
      'unreadCount': serializer.toJson<int>(unreadCount),
    };
  }

  ChatThread copyWith(
          {String? threadId,
          Value<String?> name = const Value.absent(),
          int? lastMessageTimestamp,
          int? unreadCount}) =>
      ChatThread(
        threadId: threadId ?? this.threadId,
        name: name.present ? name.value : this.name,
        lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
        unreadCount: unreadCount ?? this.unreadCount,
      );
  ChatThread copyWithCompanion(ChatThreadsCompanion data) {
    return ChatThread(
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      name: data.name.present ? data.name.value : this.name,
      lastMessageTimestamp: data.lastMessageTimestamp.present
          ? data.lastMessageTimestamp.value
          : this.lastMessageTimestamp,
      unreadCount:
          data.unreadCount.present ? data.unreadCount.value : this.unreadCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatThread(')
          ..write('threadId: $threadId, ')
          ..write('name: $name, ')
          ..write('lastMessageTimestamp: $lastMessageTimestamp, ')
          ..write('unreadCount: $unreadCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(threadId, name, lastMessageTimestamp, unreadCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatThread &&
          other.threadId == this.threadId &&
          other.name == this.name &&
          other.lastMessageTimestamp == this.lastMessageTimestamp &&
          other.unreadCount == this.unreadCount);
}

class ChatThreadsCompanion extends UpdateCompanion<ChatThread> {
  final Value<String> threadId;
  final Value<String?> name;
  final Value<int> lastMessageTimestamp;
  final Value<int> unreadCount;
  final Value<int> rowid;
  const ChatThreadsCompanion({
    this.threadId = const Value.absent(),
    this.name = const Value.absent(),
    this.lastMessageTimestamp = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatThreadsCompanion.insert({
    required String threadId,
    this.name = const Value.absent(),
    required int lastMessageTimestamp,
    this.unreadCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : threadId = Value(threadId),
        lastMessageTimestamp = Value(lastMessageTimestamp);
  static Insertable<ChatThread> custom({
    Expression<String>? threadId,
    Expression<String>? name,
    Expression<int>? lastMessageTimestamp,
    Expression<int>? unreadCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (threadId != null) 'thread_id': threadId,
      if (name != null) 'name': name,
      if (lastMessageTimestamp != null)
        'last_message_timestamp': lastMessageTimestamp,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatThreadsCompanion copyWith(
      {Value<String>? threadId,
      Value<String?>? name,
      Value<int>? lastMessageTimestamp,
      Value<int>? unreadCount,
      Value<int>? rowid}) {
    return ChatThreadsCompanion(
      threadId: threadId ?? this.threadId,
      name: name ?? this.name,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastMessageTimestamp.present) {
      map['last_message_timestamp'] = Variable<int>(lastMessageTimestamp.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatThreadsCompanion(')
          ..write('threadId: $threadId, ')
          ..write('name: $name, ')
          ..write('lastMessageTimestamp: $lastMessageTimestamp, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _threadIdMeta =
      const VerificationMeta('threadId');
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
      'thread_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chat_threads (thread_id)'));
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('saved'));
  static const VerificationMeta _messageTypeMeta =
      const VerificationMeta('messageType');
  @override
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
      'message_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('text'));
  static const VerificationMeta _localFilePathMeta =
      const VerificationMeta('localFilePath');
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
      'local_file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        messageId,
        threadId,
        senderId,
        content,
        timestamp,
        status,
        messageType,
        localFilePath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(_threadIdMeta,
          threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta));
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('message_type')) {
      context.handle(
          _messageTypeMeta,
          messageType.isAcceptableOrUnknown(
              data['message_type']!, _messageTypeMeta));
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
          _localFilePathMeta,
          localFilePath.isAcceptableOrUnknown(
              data['local_file_path']!, _localFilePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      threadId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thread_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      messageType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_type'])!,
      localFilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_file_path']),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String messageId;
  final String threadId;
  final String senderId;
  final String content;
  final int timestamp;
  final String status;
  final String messageType;
  final String? localFilePath;
  const Message(
      {required this.messageId,
      required this.threadId,
      required this.senderId,
      required this.content,
      required this.timestamp,
      required this.status,
      required this.messageType,
      this.localFilePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['thread_id'] = Variable<String>(threadId);
    map['sender_id'] = Variable<String>(senderId);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<int>(timestamp);
    map['status'] = Variable<String>(status);
    map['message_type'] = Variable<String>(messageType);
    if (!nullToAbsent || localFilePath != null) {
      map['local_file_path'] = Variable<String>(localFilePath);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      messageId: Value(messageId),
      threadId: Value(threadId),
      senderId: Value(senderId),
      content: Value(content),
      timestamp: Value(timestamp),
      status: Value(status),
      messageType: Value(messageType),
      localFilePath: localFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localFilePath),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      messageId: serializer.fromJson<String>(json['messageId']),
      threadId: serializer.fromJson<String>(json['threadId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      status: serializer.fromJson<String>(json['status']),
      messageType: serializer.fromJson<String>(json['messageType']),
      localFilePath: serializer.fromJson<String?>(json['localFilePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'threadId': serializer.toJson<String>(threadId),
      'senderId': serializer.toJson<String>(senderId),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<int>(timestamp),
      'status': serializer.toJson<String>(status),
      'messageType': serializer.toJson<String>(messageType),
      'localFilePath': serializer.toJson<String?>(localFilePath),
    };
  }

  Message copyWith(
          {String? messageId,
          String? threadId,
          String? senderId,
          String? content,
          int? timestamp,
          String? status,
          String? messageType,
          Value<String?> localFilePath = const Value.absent()}) =>
      Message(
        messageId: messageId ?? this.messageId,
        threadId: threadId ?? this.threadId,
        senderId: senderId ?? this.senderId,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        messageType: messageType ?? this.messageType,
        localFilePath:
            localFilePath.present ? localFilePath.value : this.localFilePath,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      status: data.status.present ? data.status.value : this.status,
      messageType:
          data.messageType.present ? data.messageType.value : this.messageType,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('messageId: $messageId, ')
          ..write('threadId: $threadId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status, ')
          ..write('messageType: $messageType, ')
          ..write('localFilePath: $localFilePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, threadId, senderId, content,
      timestamp, status, messageType, localFilePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.messageId == this.messageId &&
          other.threadId == this.threadId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.status == this.status &&
          other.messageType == this.messageType &&
          other.localFilePath == this.localFilePath);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> messageId;
  final Value<String> threadId;
  final Value<String> senderId;
  final Value<String> content;
  final Value<int> timestamp;
  final Value<String> status;
  final Value<String> messageType;
  final Value<String?> localFilePath;
  final Value<int> rowid;
  const MessagesCompanion({
    this.messageId = const Value.absent(),
    this.threadId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.status = const Value.absent(),
    this.messageType = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String messageId,
    required String threadId,
    required String senderId,
    required String content,
    required int timestamp,
    this.status = const Value.absent(),
    this.messageType = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : messageId = Value(messageId),
        threadId = Value(threadId),
        senderId = Value(senderId),
        content = Value(content),
        timestamp = Value(timestamp);
  static Insertable<Message> custom({
    Expression<String>? messageId,
    Expression<String>? threadId,
    Expression<String>? senderId,
    Expression<String>? content,
    Expression<int>? timestamp,
    Expression<String>? status,
    Expression<String>? messageType,
    Expression<String>? localFilePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (threadId != null) 'thread_id': threadId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (status != null) 'status': status,
      if (messageType != null) 'message_type': messageType,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? messageId,
      Value<String>? threadId,
      Value<String>? senderId,
      Value<String>? content,
      Value<int>? timestamp,
      Value<String>? status,
      Value<String>? messageType,
      Value<String?>? localFilePath,
      Value<int>? rowid}) {
    return MessagesCompanion(
      messageId: messageId ?? this.messageId,
      threadId: threadId ?? this.threadId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      localFilePath: localFilePath ?? this.localFilePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('messageId: $messageId, ')
          ..write('threadId: $threadId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('status: $status, ')
          ..write('messageType: $messageType, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChatThreadsTable chatThreads = $ChatThreadsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chatThreads, messages];
}

typedef $$ChatThreadsTableCreateCompanionBuilder = ChatThreadsCompanion
    Function({
  required String threadId,
  Value<String?> name,
  required int lastMessageTimestamp,
  Value<int> unreadCount,
  Value<int> rowid,
});
typedef $$ChatThreadsTableUpdateCompanionBuilder = ChatThreadsCompanion
    Function({
  Value<String> threadId,
  Value<String?> name,
  Value<int> lastMessageTimestamp,
  Value<int> unreadCount,
  Value<int> rowid,
});

final class $$ChatThreadsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatThreadsTable, ChatThread> {
  $$ChatThreadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.messages,
          aliasName: $_aliasNameGenerator(
              db.chatThreads.threadId, db.messages.threadId));

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager($_db, $_db.messages).filter(
        (f) =>
            f.threadId.threadId.sqlEquals($_itemColumn<String>('thread_id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatThreadsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastMessageTimestamp => $composableBuilder(
      column: $table.lastMessageTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnFilters(column));

  Expression<bool> messagesRefs(
      Expression<bool> Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatThreadsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get threadId => $composableBuilder(
      column: $table.threadId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastMessageTimestamp => $composableBuilder(
      column: $table.lastMessageTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnOrderings(column));
}

class $$ChatThreadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatThreadsTable> {
  $$ChatThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get lastMessageTimestamp => $composableBuilder(
      column: $table.lastMessageTimestamp, builder: (column) => column);

  GeneratedColumn<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => column);

  Expression<T> messagesRefs<T extends Object>(
      Expression<T> Function($$MessagesTableAnnotationComposer a) f) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatThreadsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatThreadsTable,
    ChatThread,
    $$ChatThreadsTableFilterComposer,
    $$ChatThreadsTableOrderingComposer,
    $$ChatThreadsTableAnnotationComposer,
    $$ChatThreadsTableCreateCompanionBuilder,
    $$ChatThreadsTableUpdateCompanionBuilder,
    (ChatThread, $$ChatThreadsTableReferences),
    ChatThread,
    PrefetchHooks Function({bool messagesRefs})> {
  $$ChatThreadsTableTableManager(_$AppDatabase db, $ChatThreadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatThreadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> threadId = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int> lastMessageTimestamp = const Value.absent(),
            Value<int> unreadCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatThreadsCompanion(
            threadId: threadId,
            name: name,
            lastMessageTimestamp: lastMessageTimestamp,
            unreadCount: unreadCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String threadId,
            Value<String?> name = const Value.absent(),
            required int lastMessageTimestamp,
            Value<int> unreadCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatThreadsCompanion.insert(
            threadId: threadId,
            name: name,
            lastMessageTimestamp: lastMessageTimestamp,
            unreadCount: unreadCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChatThreadsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<ChatThread, $ChatThreadsTable,
                            Message>(
                        currentTable: table,
                        referencedTable:
                            $$ChatThreadsTableReferences._messagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatThreadsTableReferences(db, table, p0)
                                .messagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.threadId == item.threadId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatThreadsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatThreadsTable,
    ChatThread,
    $$ChatThreadsTableFilterComposer,
    $$ChatThreadsTableOrderingComposer,
    $$ChatThreadsTableAnnotationComposer,
    $$ChatThreadsTableCreateCompanionBuilder,
    $$ChatThreadsTableUpdateCompanionBuilder,
    (ChatThread, $$ChatThreadsTableReferences),
    ChatThread,
    PrefetchHooks Function({bool messagesRefs})>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String messageId,
  required String threadId,
  required String senderId,
  required String content,
  required int timestamp,
  Value<String> status,
  Value<String> messageType,
  Value<String?> localFilePath,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> messageId,
  Value<String> threadId,
  Value<String> senderId,
  Value<String> content,
  Value<int> timestamp,
  Value<String> status,
  Value<String> messageType,
  Value<String?> localFilePath,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatThreadsTable _threadIdTable(_$AppDatabase db) =>
      db.chatThreads.createAlias(
          $_aliasNameGenerator(db.messages.threadId, db.chatThreads.threadId));

  $$ChatThreadsTableProcessedTableManager get threadId {
    final $_column = $_itemColumn<String>('thread_id')!;

    final manager = $$ChatThreadsTableTableManager($_db, $_db.chatThreads)
        .filter((f) => f.threadId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_threadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageType => $composableBuilder(
      column: $table.messageType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => ColumnFilters(column));

  $$ChatThreadsTableFilterComposer get threadId {
    final $$ChatThreadsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.chatThreads,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatThreadsTableFilterComposer(
              $db: $db,
              $table: $db.chatThreads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageType => $composableBuilder(
      column: $table.messageType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath,
      builder: (column) => ColumnOrderings(column));

  $$ChatThreadsTableOrderingComposer get threadId {
    final $$ChatThreadsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.chatThreads,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatThreadsTableOrderingComposer(
              $db: $db,
              $table: $db.chatThreads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get messageType => $composableBuilder(
      column: $table.messageType, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => column);

  $$ChatThreadsTableAnnotationComposer get threadId {
    final $$ChatThreadsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.threadId,
        referencedTable: $db.chatThreads,
        getReferencedColumn: (t) => t.threadId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatThreadsTableAnnotationComposer(
              $db: $db,
              $table: $db.chatThreads,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool threadId})> {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> messageId = const Value.absent(),
            Value<String> threadId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> messageType = const Value.absent(),
            Value<String?> localFilePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            messageId: messageId,
            threadId: threadId,
            senderId: senderId,
            content: content,
            timestamp: timestamp,
            status: status,
            messageType: messageType,
            localFilePath: localFilePath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String messageId,
            required String threadId,
            required String senderId,
            required String content,
            required int timestamp,
            Value<String> status = const Value.absent(),
            Value<String> messageType = const Value.absent(),
            Value<String?> localFilePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            messageId: messageId,
            threadId: threadId,
            senderId: senderId,
            content: content,
            timestamp: timestamp,
            status: status,
            messageType: messageType,
            localFilePath: localFilePath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MessagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({threadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (threadId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.threadId,
                    referencedTable:
                        $$MessagesTableReferences._threadIdTable(db),
                    referencedColumn:
                        $$MessagesTableReferences._threadIdTable(db).threadId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool threadId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChatThreadsTableTableManager get chatThreads =>
      $$ChatThreadsTableTableManager(_db, _db.chatThreads);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
}
