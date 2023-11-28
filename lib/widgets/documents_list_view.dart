import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/utilities/format.dart';

class DocumentsListView extends StatelessWidget {
  final List<Document> documents;
  final Document? downloadingDocument;
  final void Function(Document)? onTapDownload;
  final bool enabled;

  const DocumentsListView({
    super.key,
    required this.documents,
    this.downloadingDocument,
    this.onTapDownload,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final document = documents[index];

        return DocumentListItem(
          title: document.title,
          subtitle: "${document.fileSize}, ${document.fileType}",
          isDownloading: document.id == downloadingDocument?.id,
          fileSize: Format.fileSize(document.fileSize),
          fileType: Format.fileType(document.fileType),
          onTap: enabled && downloadingDocument == null
              ? () {
                  onTapDownload?.call(document);
                }
              : null,
        );
      },
    );
  }
}

class DocumentListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDownloading;
  final String fileSize;
  final String fileType;

  const DocumentListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileSize,
    required this.fileType,
    this.onTap,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap?.call() : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenLeftPadding,
        ),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              color: ClientConfig.getColorScheme().secondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ClientConfig.getTextStyleScheme()
                        .heading4
                        .copyWith(color: ClientConfig.getCustomColors().neutral900),
                  ),
                  Text(
                    "$fileSize, $fileType",
                    style: ClientConfig.getTextStyleScheme()
                        .bodySmallRegular
                        .copyWith(color: ClientConfig.getCustomColors().neutral700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            isDownloading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  )
                : Icon(Icons.download_outlined,
                    color: onTap != null
                        ? ClientConfig.getColorScheme().tertiary
                        : ClientConfig.getCustomColors().neutral500),
          ],
        ),
      ),
    );
  }
}
