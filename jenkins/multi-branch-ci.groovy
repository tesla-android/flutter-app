def getRepoURL() {
    sh "git config --get remote.origin.url > .git/remote-url"
    return readFile(".git/remote-url").trim()
}

def getCommitSha() {
    sh "git rev-parse HEAD > .git/current-commit"
    return readFile(".git/current-commit").trim()
}

def getCurrentBranch() {
    return env.BRANCH_NAME;
}

void setBuildStatus(String message, String state) {
    repoUrl = getRepoURL()
    commitSha = getCommitSha()

    step([
            $class            : 'GitHubCommitStatusSetter',
            reposSource       : [$class: "ManuallyEnteredRepositorySource", url: repoUrl],
            commitShaSource   : [$class: "ManuallyEnteredShaSource", sha: commitSha],
            errorHandlers     : [[$class: 'ShallowAnyErrorHandler']],
            statusResultSource: [$class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]]]
    ]);
}

pipeline {
    agent { label 'flutter' }

    options {
        buildDiscarder(logRotator(artifactNumToKeepStr: '10', artifactDaysToKeepStr:'90'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Get dependencies') {
            steps {
                sh('flutter pub get -v')
            }
        }
        stage('Build runner') {
            steps {
                sh('flutter packages pub run build_runner build --delete-conflicting-outputs')
            }
        }
        stage('Build') {
            steps {
                script {
                    SENTRY_RELEASE = 'flutter-app-ci-' + getCurrentBranch()  + '-' + getCommitSha()
                }
                sh('flutter build web --profile --web-renderer html --source-maps --dart-define=SENTRY_RELEASE=' + SENTRY_RELEASE)
            }
        }
        //stage('Upload debug symbols to Sentry') {
        //    steps {
        //        sh('sentry-cli releases new ' + SENTRY_RELEASE)
        //        sh('sentry-cli releases files ' + SENTRY_RELEASE + ' upload-sourcemaps . --ext dart --dist 1')
        //        sh('sentry-cli releases files ' + SENTRY_RELEASE + ' upload-sourcemaps "build/web" --ext map --ext js --dist 1')
        //        sh('sentry-cli releases finalize ' + SENTRY_RELEASE)
        //    }
        //}
        stage('Prepare artifacts') {
            steps {
                sh('cd build/web && zip ' + SENTRY_RELEASE + '.zip -r *')
            }
        }
    }
    post {
        success {
            setBuildStatus("Build succeeded", "SUCCESS");
            archiveArtifacts artifacts: 'build/web/*.zip', fingerprint: true
            cleanWs()
        }
        failure {
            setBuildStatus("Build failed", "FAILURE");
            cleanWs()
        }
    }
}
