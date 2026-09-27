#include "AiPanel.h"

#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QVBoxLayout>

AiPanel::AiPanel(QWidget *parent) : QWidget(parent)
{
	setObjectName("assistantPanel");
	setMinimumWidth(250);

	auto *layout = new QVBoxLayout(this);
	layout->setContentsMargins(12, 12, 12, 12);
	layout->setSpacing(8);

	auto *eyebrow = new QLabel(tr("DESIGN ASSISTANT"), this);
	eyebrow->setObjectName("assistantEyebrow");
	layout->addWidget(eyebrow);

	auto *status = new QLabel(tr("OFFLINE  /  NOT CONFIGURED"), this);
	status->setObjectName("assistantStatus");
	layout->addWidget(status);

	auto *history = new QLabel(tr("Assistant responses will appear here."), this);
	history->setObjectName("assistantHistory");
	history->setWordWrap(true);
	history->setAlignment(Qt::AlignLeft | Qt::AlignTop);
	history->setMinimumHeight(120);
	layout->addWidget(history, 1);

	auto *context = new QLabel(tr("ACTIVE DESIGN\nContext will appear when a design is open."), this);
	context->setObjectName("assistantContext");
	context->setWordWrap(true);
	layout->addWidget(context);

	auto *prompt = new QLineEdit(this);
	prompt->setObjectName("assistantPrompt");
	prompt->setPlaceholderText(tr("Describe a modeling change…"));
	prompt->setEnabled(false);
	layout->addWidget(prompt);

	auto *send = new QPushButton(tr("SEND  ↗"), this);
	send->setObjectName("assistantSend");
	send->setEnabled(false);
	layout->addWidget(send);
}
