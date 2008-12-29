#===============================================================================
#       AUTHOR:  Alec Chen <ylchenzr.tsmc.com>
#===============================================================================

package GUI;
use Wx qw(:everything);
use Wx::Event qw(:everything);
use base 'Wx::Frame';
use Readonly;
use version; our $VERSION = qv('0.0.1');
use Cwd;
use Rubyish::Attribute;

Readonly my $NAME => 'bobson';

attr_accessor 'input', 'output';

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(
        undef, -1, $NAME,
        wxDefaultPosition, [600,350],
        wxDEFAULT_FRAME_STYLE|wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN,
    );

    Wx::InitAllImageHandlers();

    # menu
    my $menubar  = Wx::MenuBar->new;
    my $file = Wx::Menu->new;
    $file->Append( wxID_EXIT, "E&xit" );

    my $help = Wx::Menu->new;
    $help->Append( wxID_ABOUT, "&About..." );

    $menubar->Append( $file, "&File" );
    $menubar->Append( $help, "&Help" );

    $self->SetMenuBar( $menubar );

    EVT_MENU( $self, wxID_ABOUT, \&on_about );
    EVT_MENU( $self, wxID_EXIT, sub { $self->Close } );

    # split window
    my $split = Wx::SplitterWindow->new(
        $self, -1, wxDefaultPosition, wxDefaultSize,
        wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN,
    );

    my $text = Wx::TextCtrl->new(
        $split, -1, q{},
        wxDefaultPosition, wxDefaultSize,
        wxTE_READONLY|wxTE_MULTILINE|wxNO_FULL_REPAINT_ON_RESIZE,
    );

    my $log = Wx::LogTextCtrl->new( $text );
    Wx::Log::SetActiveTarget( $log );

    # file picker
    my $panel = Wx::Panel->new($split, -1);

    my $input_label  = Wx::StaticText->new($panel, -1, 'Input',  [35,15]);
    my $output_label = Wx::StaticText->new($panel, -1, 'Output', [20,50]);

    my $input_fp = Wx::FilePickerCtrl->new(
        $panel, -1, cwd(),
        'Choose input file name',
        'Excel spreadsheets (*.xls)|*.xls|All files (*.*)|*.*',
        [70, 10], [450, 30], wxPB_USE_TEXTCTRL,
    );

    my $output_fp = Wx::FilePickerCtrl->new(
        $panel, -1, cwd(),
        'Choose output file name',
        'Plain Text (*.txt)|*.txt|All files (*.*)|*.*',
        [70, 45], [450, 30], wxPB_USE_TEXTCTRL,
    );

    EVT_FILEPICKER_CHANGED( $self, $input_fp,  \&on_input_change  );
    EVT_FILEPICKER_CHANGED( $self, $output_fp, \&on_output_change );

    # buttons
    my $run_btn  = Wx::Button->new( $panel, -1, 'Run',  [180,80] );
    my $exit_btn = Wx::Button->new( $panel, -1, 'Exit', [280,80] );

    #EVT_BUTTON( $panel, $run_btn,  \&create_control);
    EVT_BUTTON( $panel, $exit_btn, sub { $self->Close() } );

    $split->SplitHorizontally( $panel, $text, 120 );

    # misc
    $self->SetIcon( Wx::GetWxPerlIcon() );
    Wx::LogMessage( "Welcome to wxPerl!" );

    return $self;
}

sub on_input_change {
    my( $self, $event ) = @_;
    my $input = $event->GetPath;
    $self->input($input);
    Wx::LogMessage( "Input changed (%s)", $input );
}

sub on_output_change {
    my( $self, $event ) = @_;
    my $output = $event->GetPath;
    $self->output($output);
    Wx::LogMessage( "Output changed (%s)", $output );
}

sub on_about {   
    my $self = shift;
    my $info = Wx::AboutDialogInfo->new;
    $info->SetName($NAME);
    $info->SetVersion($VERSION);
    $info->SetDescription('...');
    $info->SetCopyright('Copyright (c) 2008 Alec Chen');
    $info->AddDeveloper('Alec Chen <alec@cpan.org>');
    $info->AddArtist('Alec Chen <alec@cpan.org>');
    Wx::AboutBox($info);
    return;
}

1;