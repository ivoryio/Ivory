import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/documents/documents_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingContractsConfirmScreen extends StatefulWidget {
  static const routeName = "/onboardingContractsConfirmScreen";

  const OnboardingContractsConfirmScreen({super.key});

  @override
  State<OnboardingContractsConfirmScreen> createState() => _OnboardingContractsConfirmScreenState();
}

class _OnboardingContractsConfirmScreenState extends State<OnboardingContractsConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DocumentsViewModel>(
      onInit: (store) => store.dispatch(GetDocumentsCommandAction()),
      converter: (store) => DocumentsPresenter.present(
        documentsState: store.state.documentsState,
        downloadDocumentState: store.state.downloadDocumentState,
        confirmDocumentsState: store.state.confirmDocumentsState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is DocumentsConfirmedViewModel) {
          log("Documents confirmed");
        }
      },
      distinct: true,
      builder: (context, viewModel) => ScreenScaffold(
        shouldPop: viewModel is! DocumentsConfirmingViewModel,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppToolbar(
              richTextTitle: StepRichTextTitle(step: 2, totalSteps: 7),
              actions: const [AppbarLogo()],
              backButtonAppearanceDisabled: viewModel is DocumentsConfirmingViewModel,
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 7),
            const SizedBox(height: 16),
            viewModel is DocumentsLoadingViewModel
                ? _buildLoadingContent()
                : viewModel is DocumentsFetchedViewModel
                    ? _buildFetchedDocumentsContent(viewModel)
                    : const SizedBox(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Expanded(
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Read & confirm contracts", style: ClientConfig.getTextStyleScheme().heading2),
            const SizedBox(height: 24),
            Text(
              "Please bear with us a couple of seconds while we create your contracts...",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 128,
                  width: 128,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 12,
                    color: ClientConfig.getColorScheme().secondary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFetchedDocumentsContent(DocumentsFetchedViewModel viewModel) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Text("Read & confirm contracts", style: ClientConfig.getTextStyleScheme().heading2),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  const TextSpan(text: "Before opening your bank account, "),
                  TextSpan(
                    text: "review and confirm ",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(text: "our contract terms and conditions. \n"),
                  TextSpan(
                    text: "Download and read ",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(
                    text:
                        "each contract by tapping the 'Download' button next to it. You'll sign your “Credit Card Application” in a later step.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            itemCount: viewModel.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final document = viewModel.documents[index];

              return DocumentListItem(
                title: document.title,
                subtitle: "${document.fileSize}, ${document.fileType}",
                isDownloading:
                    viewModel is DocumentDownloadingViewModel && document.id == viewModel.downloadingDocument.id,
                fileSize: Format.fileSize(document.fileSize),
                fileType: document.fileType,
                onTapDownload: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    DownloadDocumentCommandAction(document: viewModel.documents[index]),
                  );
                },
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: PrimaryButton(
              isLoading: viewModel is DocumentsConfirmingViewModel,
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(
                  ConfirmDocumentsCommandAction(documents: viewModel.documents),
                );
              },
              text: "Confirm & continue",
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTapDownload;
  final bool isDownloading;
  final String fileSize;
  final String fileType;

  const DocumentListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fileSize,
    required this.fileType,
    this.onTapDownload,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isDownloading) {
          onTapDownload?.call();
        }
      },
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
                : Icon(Icons.download_outlined, color: ClientConfig.getColorScheme().tertiary),
          ],
        ),
      ),
    );
  }
}
